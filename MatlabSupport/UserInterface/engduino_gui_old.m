function varargout = engduino_gui(varargin)
% ENGDUINO_GUI MATLAB code for engduino_gui.fig
%      ENGDUINO_GUI, by itself, creates a new ENGDUINO_GUI or raises the existing
%      singleton*.
%
%      H = ENGDUINO_GUI returns the handle to a new ENGDUINO_GUI or the handle to
%      the existing singleton*.
%
%      ENGDUINO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENGDUINO_GUI.M with the given input arguments.
%
%      ENGDUINO_GUI('Property','Value',...) creates a new ENGDUINO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engduino_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engduino_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help engduino_gui

% Last Modified by GUIDE v2.5 29-Jul-2014 00:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @engduino_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @engduino_gui_OutputFcn, ...
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


% --- Executes just before engduino_gui is made visible.
function engduino_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engduino_gui (see VARARGIN)

% Engduino variables
port = 'demo';
handles.e = engduino(port);
handles.sen_isRunning = 0;
handles.cnt = struct('bla', 0);
handles.cnt = 0;
handles.temperature = [];
handles.sen_timer = timer(...
    'ExecutionMode', 'fixedRate', ...   % Run timer repeatedly
    'Period', 0.1, ...                % Initial period is 1 sec.
    'TimerFcn', {@sen_timer_interrupr, hObject}); % Specify callback

 
 
hold on;
handles.plotHandle = plot(nan, nan,'Marker', 'o', ....
                                             'MarkerSize', 6, ...
                                             'MarkerEdgeColor', [0.3 0.7 1], ...
                                             'LineWidth', 2, ...
                                             'Color', [0 0 1]);

grid on;
% Choose default command line output for engduino_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes engduino_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = engduino_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in b_sen_startStop.
function b_sen_startStop_Callback(hObject, eventdata, handles)
    % hObject    handle to b_sen_startStop (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Hint: get(hObject,'Value') returns toggle state of b_sen_startStop
    v = get(hObject, 'Value');
    if v == 1
        handles.sen_isRunning = 1;
        set(hObject, 'String', 'Stop');
        start(handles.sen_timer);
    else
        handles.sen_isRunning = 0;
        set(hObject, 'String', 'Start');
        stop(handles.sen_timer);
    end
    
    % Update handles structure
    guidata(hObject, handles);

% --- Executes on selection change in popup_sensors.
function popup_sensors_Callback(hObject, eventdata, handles)
% hObject    handle to popup_sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_sensors contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_sensors
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_sensors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% START USER CODE
% Necessary to provide this function to prevent timer callback
% from causing an error after GUI code stops executing.
% Before exiting, if the timer is running, stop it.
if strcmp(get(handles.sen_timer, 'Running'), 'on')
    stop(handles.sen_timer);
end
disp('close!')
% Destroy timer
delete(handles.sen_timer)
% END USER CODE

% Hint: delete(hObject) closes the figure
delete(hObject);


function sen_timer_interrupr(hObject, eventdata, hfigure)
% Timer timer1 callback, called each time timer iterates.

    handles = guidata(hfigure);
    disp(['cnt: ' num2str(handles.cnt)]);
    handles.cnt = handles.cnt + 1;
    handles.temperature = [handles.temperature, handles.e.getTemperature()];
    set(handles.plotHandle, 'YData', handles.temperature, 'XData', (1:length(handles.temperature)));
    %drawnow;
    % Update handles structure
    guidata(hfigure, handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
