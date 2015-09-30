function varargout = DiceRollingExample(varargin)
% DICEROLLINGEXAMPLE MATLAB code for DiceRollingExample.fig
%      DICEROLLINGEXAMPLE, by itself, creates a new DICEROLLINGEXAMPLE or raises the existing
%      singleton*.
%
%      H = DICEROLLINGEXAMPLE returns the handle to a new DICEROLLINGEXAMPLE or the handle to
%      the existing singleton*.
%
%      DICEROLLINGEXAMPLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DICEROLLINGEXAMPLE.M with the given input arguments.
%
%      DICEROLLINGEXAMPLE('Property','Value',...) creates a new DICEROLLINGEXAMPLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DiceRollingExample_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DiceRollingExample_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DiceRollingExample

% Last Modified by GUIDE v2.5 26-Aug-2015 16:26:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DiceRollingExample_OpeningFcn, ...
                   'gui_OutputFcn',  @DiceRollingExample_OutputFcn, ...
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

function setGlobalDiceNumber(val)
global diceNumber;
diceNumber=val;    

function r = getGlobalDiceNumber()
global diceNumber;
r = diceNumber;

function setGlobalDiceN(val)
global throw;
throw = val;

function r = getGlobalDiceN()
global throw;
r = throw;

function setGlobalOdd(val)
global odd;
odd = val;

function r = getGlobalOdd()
global odd;
r = odd;

function setGlobalEven(val)
global even;
even = val;

function r = getGlobalEven()
global even;
r = even;

function r = getGlobalCount()
global count;
r = count;

function setGlobalCount(val)
global count;
count = val;

function r = getGlobalStart()
global start;
r = start;

function setGlobalStart(val)
global start;
start = val;

function init(hObject)
handles = guidata(hObject);
handles.board = [];
setGlobalDiceNumber(1);
setGlobalDiceN(0);
setGlobalCount(1);
setGlobalOdd(0);
setGlobalEven(0);
setGlobalStart(false);
guidata(hObject, handles);

function update_graph(hObject)
handles = guidata(hObject);
x = {'odd' 'even'};
data1 = getGlobalOdd();
data2 = getGlobalEven();
y = [data1 data2];
bar(handles.axes1,y,0.4);
set(gca,'XTickLabel',x);
% set y label to integer
set(gca,'ytick',0:100);

function connect_board(hObject)
    handles = guidata(hObject);

    %cons = @() engduino(get(handles.board_port, 'string'));
    cons = @() engduino('COM4');

    try
        if (~ isempty(handles.board))
            delete(handles.board);
        end
        handles.board = cons();

        guidata(hObject, handles);
    catch e
        disp(e.message);
        %update('Error');
    end


% --- Executes just before DiceRollingExample is made visible.
function DiceRollingExample_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DiceRollingExample (see VARARGIN)

% Choose default command line output for DiceRollingExample
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

init(hObject);

% UIWAIT makes DiceRollingExample wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DiceRollingExample_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function DiceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to DiceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newval = hObject.Value;                         %get value from the slider
newval = round(newval);                         %round off this value
set(hObject, 'Value', newval);                  %set slider position to rounded off value
disp(['Slider moved to ' num2str(newval)]);     %display the value pointed by slider
setGlobalDiceNumber(newval);
set(handles.edit5, 'String', num2str(newval));

% --- Executes during object creation, after setting all properties.
function DiceSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DiceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
connect_board(hObject);

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
skip = false;
if getGlobalStart==false
    setGlobalStart(true);
    button = findobj('Tag','pushbutton1');
    set(button,'String','Stop');
else
    setGlobalStart(false);
    button = findobj('Tag','pushbutton1');
    set(button,'String','Start');
end    

while(getGlobalStart())
while(not(RollDice(handles.board)))
    if getGlobalStart==false
        button = findobj('Tag','pushbutton1');
        set(button,'String','Start');
        skip = true;
        break;
    else
        button = findobj('Tag','pushbutton1');
        set(button,'String','Stop');   
    end   
    disp('hello');
end
if (skip==false);
xmin =1*getGlobalDiceNumber();
xmax =6*getGlobalDiceNumber();
dice_number = randi([xmin xmax],1);

count = getGlobalCount();
text = strcat('try',num2str(count));
count = count+1;
setGlobalCount(count);
if(count==19)
    setGlobalCount(1);
end
h = findobj('Tag',text);
textLabel = num2str(dice_number);
set(h,'String',textLabel);
i = getGlobalDiceN();
i = i+1;
setGlobalDiceN(i);
k = findobj('Tag','Samples');
set(k,'String',i);


diceStr = findobj('Tag','DiceNumber');
set(diceStr,'String',dice_number);

digit = mod(dice_number,2);

if(digit==0)
    evenN = getGlobalEven();
    evenN = evenN+1;
    setGlobalEven(evenN);
else
    oddN = getGlobalOdd();
    oddN = oddN+1;
    setGlobalOdd(oddN);
end

even_number = getGlobalEven;
[numerator denominator] = rat(even_number/(i));

k = findobj('Tag','actual_num');
set(k,'String',numerator);

k = findobj('Tag','actual_dem');
set(k,'String',denominator);

disp(numerator);
update_graph(hObject);
pause(0.1);
end
end


function actual_dem_Callback(hObject, eventdata, handles)
% hObject    handle to actual_dem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of actual_dem as text
%        str2double(get(hObject,'String')) returns contents of actual_dem as a double


% --- Executes during object creation, after setting all properties.
function actual_dem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to actual_dem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function actual_num_Callback(hObject, eventdata, handles)
% hObject    handle to actual_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of actual_num as text
%        str2double(get(hObject,'String')) returns contents of actual_num as a double


% --- Executes during object creation, after setting all properties.
function actual_num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to actual_num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
