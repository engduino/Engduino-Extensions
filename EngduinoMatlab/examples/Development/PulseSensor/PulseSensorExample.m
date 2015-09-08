function varargout = PulseSensorExample(varargin)
% PULSESENSOREXAMPLE MATLAB code for PulseSensorExample.fig
%      PULSESENSOREXAMPLE, by itself, creates a new PULSESENSOREXAMPLE or raises the existing
%      singleton*.
%
%      H = PULSESENSOREXAMPLE returns the handle to a new PULSESENSOREXAMPLE or the handle to
%      the existing singleton*.
%
%      PULSESENSOREXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PULSESENSOREXAMPLE.M with the given input arguments.
%
%      PULSESENSOREXAMPLE('Property','Value',...) creates a new PULSESENSOREXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PulseSensorExample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PulseSensorExample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PulseSensorExample

% Last Modified by GUIDE v2.5 02-Sep-2015 11:18:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PulseSensorExample_OpeningFcn, ...
                   'gui_OutputFcn',  @PulseSensorExample_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% set method for pulse sensor start/stop status
function setStartSensor(val)
global startPulse;
startPulse = val;

% get method for pulse sensor start/stop status
function r = getStartSensor()
global startPulse;
r = startPulse;

function setBgColour(val)
global bgColour;
bgColour=val;

function r = getBgColour()
global bgColour;
r = bgColour;

% initialisation method
function init(hObject)
handles = guidata(hObject);
handles.board = [];
setStartSensor(false);
% draw circle in GUI
angle = linspace(0,2*pi,360);
x = cos(angle);
y = sin(angle);
handles.circle = plot(handles.axes3,x,y);
set(handles.circle,'linewidth',5,'color','b');
axis('equal');
% Turn off the background box
axis(handles.axes1,'off');
axis(handles.axes3,'off');
axis(handles.axes16,'off');
% Turn off axis
setBgColour(get(handles.cat1,'BackgroundColor'));
% update GUI data
guidata(hObject, handles);

% make connection to Engduino
function status = connect_board(hObject)
handles = guidata(hObject);
cons = @() engduino('COM4');
try
    if (~ isempty(handles.board))
        delete(handles.board);
    end
    handles.board = cons();
    guidata(hObject, handles);
    status = true;
catch e
    disp(e.message);
    status = false;
    
end

function update_graph(hObject)
switchColour = true;
% retrieve GUI Data
handles = guidata(hObject);
% Read pulse sensor initialisation
% Set reading frequency [Hz] - readings per second.
frequency = 100; 
% Set circle buffer length [samples]
buffSize = 100;
% Mean time between two beats (seconds)
mtbb = 0.5; % 120 beats per second (-> 60/mtbb)
% Initialize variables
tic
i = 1;
circBuff = nan(2, 3);
time = repmat(toc, 2, 3);
t0 = toc;
threshold = 50;
newest_lpf = 2^9;
last_peak = 0;
pulse = -1; 
%------------------------------------------
hold on;
plotHandle = plot(handles.axes1, time, circBuff, 'LineWidth', 2);

% Peak detection graphic
plotHandle(3).Color = [1, .2, .2];
plotHandle(3).Marker = '.';
plotHandle(3).MarkerSize = 50;
pulse_counter=0;
while(getStartSensor())   
    input = get(handles.age, 'string');
    age = str2num(input);
    if (isempty(age))
       setStartSensor(false);
       set(handles.pushbutton1,'String','start');
       axis(handles.axes1,'off');
       break;
    end
    %-------------- reading pulse ----------------------------
    % Read analog value from pin 3.
    newest = handles.board.analogRead(3);
    newest = newest(2);
    % Lowpass filter
    % Higher value of alpha (a) will follow into less filtered signal.
    a = 0.2;
    newest_lpf  = (1-a)*newest_lpf + a*newest; 
    % Detect pulse
    if(newest > (newest_lpf + threshold) && (toc - last_peak) > mtbb)
        pulse = newest;
        last_peak = toc;
    end
    % Find peak
    if(pulse > 0 && newest > pulse)
        pulse = newest;
    elseif(pulse > 0 && newest < pulse)
        circBuff(end, 3) = pulse;
        pulse = -1;
    end
    % Add the newest sample into the buffer.
    if (i < buffSize)
        circBuff(i, :) = [newest, newest_lpf, nan];
        time(i, :) = repmat(toc, 1, 3);
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end, :); [newest, newest_lpf, nan]];
        time = [time(2:end, :); repmat(toc, 1, 3)];
    end
    % Set xlim and ylim for Plot.
    if (~isvalid(handles.axes1)), return; end;
    xlim(handles.axes1, [min(time(:,1)) max(time(:,1))+10e-9]);
    ymin = min(circBuff(:, 1));
    ymax = max(circBuff(:, 1))+10e-9;
    span = (ymax - ymin)*0.1;
    ylim(handles.axes1, [ymin - span, ymax + span]);
    % Adjust threshold depends on a signal scale. 
    th_length = floor(buffSize/3);
    if (i > th_length)
        threshold = (max(circBuff(end-th_length:end, 1)) ... 
            - min(circBuff(end-th_length:end, 1)))/3;
        threshold = max(20, threshold); % Keep threshold above certain level.
    end
    % Plot data.
    set(plotHandle(1), 'YData', circBuff(:, 1), 'XData', time(:, 1));
    set(plotHandle(2), 'YData', circBuff(:, 2), 'XData', time(:, 1));
    set(plotHandle(3), 'YData', circBuff(:, 3), 'XData', time(:, 1));
    % Calculate heart rate as beats per second. We use mean value from
    % beats detected in circular buffer. The 'trimmean' function is used to
    % minimize efect of outliners.
    t = time(~isnan(circBuff(:, 3)), 1);
    dt = 60./(t(2:end) - t(1:end-1));
    bps = trimmean(dt, 50);
    bps_std = std(dt(dt < bps*1.3 & dt > bps*0.7));
    % Set heartrate result to text.
    textLabel = num2str(floor(bps));
    set(handles.reading,'String',textLabel);
    axis(handles.axes1,'off');
    %---------End of pulse update---------
    
    %---------update temperature----------
    temperature = handles.board.getTemperature();
    temperature = floor(temperature*10)/10;
    temperatureText = num2str(temperature);
    set(handles.temperature,'String',temperatureText);
    
    maxHR = 220 - age;
    disp(maxHR);
    
    cat1Lower = 0.5*maxHR;
    cat2Lower = 0.6*maxHR;
    cat3Lower = 0.7*maxHR;
    cat4Lower = 0.8*maxHR;
    cat4Higher = 0.9*maxHR;
    if bps>=cat4Higher
        set(handles.cat5,'BackgroundColor','r');
        set(handles.cat4,'BackgroundColor',getBgColour());
        set(handles.cat3,'BackgroundColor',getBgColour());
        set(handles.cat2,'BackgroundColor',getBgColour());
        set(handles.cat1,'BackgroundColor',getBgColour());
    elseif (bps>=cat4Lower)&&(bps<cat4Higher)
        set(handles.cat4,'BackgroundColor','r');
        set(handles.cat5,'BackgroundColor',getBgColour());
        set(handles.cat3,'BackgroundColor',getBgColour());
        set(handles.cat2,'BackgroundColor',getBgColour());
        set(handles.cat1,'BackgroundColor',getBgColour());
    elseif (bps>=cat3Lower)&&(bps<cat4Lower)
        set(handles.cat3,'BackgroundColor','r');
        set(handles.cat4,'BackgroundColor',getBgColour());
        set(handles.cat5,'BackgroundColor',getBgColour());
        set(handles.cat2,'BackgroundColor',getBgColour());
        set(handles.cat1,'BackgroundColor',getBgColour());
    elseif (bps>=cat2Lower)&&(bps<cat3Lower)
        set(handles.cat2,'BackgroundColor','r');
        set(handles.cat4,'BackgroundColor',getBgColour());
        set(handles.cat3,'BackgroundColor',getBgColour());
        set(handles.cat5,'BackgroundColor',getBgColour());
        set(handles.cat1,'BackgroundColor',getBgColour());
    elseif (bps>=cat1Lower)&&(bps<cat2Lower)
        set(handles.cat1,'BackgroundColor','r');
        set(handles.cat4,'BackgroundColor',getBgColour());
        set(handles.cat3,'BackgroundColor',getBgColour());
        set(handles.cat2,'BackgroundColor',getBgColour());
        set(handles.cat5,'BackgroundColor',getBgColour());
    else
        set(handles.cat1,'BackgroundColor',getBgColour());
        set(handles.cat4,'BackgroundColor',getBgColour());
        set(handles.cat3,'BackgroundColor',getBgColour());
        set(handles.cat2,'BackgroundColor',getBgColour());
        set(handles.cat5,'BackgroundColor',getBgColour());
    end
    % Animate circle colour changing
    axes(handles.axes3);
    if(switchColour)
        set(handles.circle,'linewidth',5,'color','r');
        switchColour = false;
    else
        set(handles.circle,'linewidth',5,'color','b');
        switchColour = true;
    end
    %Delaying animation
    pause(1/frequency);
    i = i + 1;
end

% --- Executes just before PulseSensorExample is made visible.
function PulseSensorExample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PulseSensorExample (see VARARGIN)

% Choose default command line output for PulseSensorExample
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
set(gca,'visible','off');
init(hObject);
axes(handles.axes16);
k = imread('heart.png');
imshow(k);
axes(handles.heartZoneChart);
j = imread('heartratew.jpg');
imshow(j);

% UIWAIT makes PulseSensorExample wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = PulseSensorExample_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button = findobj('Tag','pushbutton1');
if getStartSensor()==false
    status = connect_board(hObject);
    if(status)
        set(button,'String','stop');
        setStartSensor(true);
        update_graph(hObject);
    end;
else
    set(button,'String','start');
    setStartSensor(false);
end

function age_Callback(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of age as text
%        str2double(get(hObject,'String')) returns contents of age as a double


% --- Executes during object creation, after setting all properties.
function age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
