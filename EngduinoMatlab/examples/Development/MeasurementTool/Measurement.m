function varargout = Measurement(varargin)
% MEASUREMENT MATLAB code for Measurement.fig
%      MEASUREMENT, by itself, creates a new MEASUREMENT or raises the existing
%      singleton*.
%
%      H = MEASUREMENT returns the handle to a new MEASUREMENT or the handle to
%      the existing singleton*.
%
%      MEASUREMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MEASUREMENT.M with the given input arguments.
%
%      MEASUREMENT('Property','Value',...) creates a new MEASUREMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Measurement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Measurement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Measurement

% Last Modified by GUIDE v2.5 22-Sep-2015 13:06:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Measurement_OpeningFcn, ...
                   'gui_OutputFcn',  @Measurement_OutputFcn, ...
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



% Initialisation Method
function init(hObject)
handles = guidata(hObject);
handles.board = [];
% Turn off the background box
axis(handles.measureDistanceAxes,'off');
axes(handles.measureDistanceAxes);
img1 = imread('measuredistance.png');
imshow(img1);
axis(handles.measureHeightAxes,'off');
axes(handles.measureHeightAxes);
img2 = imread('measureheight.png');
imshow(img2);
% update GUI data
guidata(hObject, handles);

% Make connection to Engduino
function status = connect_board(hObject)
handles = guidata(hObject);
cons = @() engduino('COM4');
try
    if (isempty(handles.board))
        delete(handles.board);
    end
    handles.board = cons();
    guidata(hObject, handles);
    status = true;
catch e
    disp(e.message);
    status = false; 
end

function main_program (hObject)
handles = guidata(hObject);
frequency = 10;

measure_distance = true;
distance =0;
temp_height =0;
object_height=0;
while(1)
    
    input = get(handles.heightEditBox,'string');
    user_height = str2num(input);
    height = user_height-0.3;
    newReading = handles.board.getAccelerometer();
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    outer_angle = atand(gz/gy);
    inner_angle = 90-outer_angle;
    angleInRadians = degtorad(inner_angle);
    
    if(handles.board.getButton())
        if(measure_distance)
            measure_distance=false;
        else
            measure_distance=true();
        end
    end
    
    if(measure_distance)
        % measuring distance and update the distance
        if(inner_angle>=90||inner_angle<=0)
            textLabel = 'Max';
            set(handles.distanceText,'String',textLabel);
        else
            
            distance = height*tan(angleInRadians);
    
            round_up_distance = round(distance*100)/100;
            textLabel = num2str(round_up_distance);
            set(handles.distanceText,'String',textLabel);
        end
    else
        % measuring height and update the height
        temp_height = distance/(tan(angleInRadians));
        object_height = height-temp_height;
        round_up_object_height = round(object_height*100)/100;
        textLabel2 = num2str(round_up_object_height);
        set(handles.heightText,'String',textLabel2);
    end
    disp('distance');
    disp(distance);
    disp('object_height');
    disp(object_height);
    pause (1/frequency);
end

% --- Executes just before Measurement is made visible.
function Measurement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Measurement (see VARARGIN)

% Choose default command line output for Measurement
handles.output = hObject;
init(hObject);
% Update handles structure
connect_board(hObject);
main_program(hObject);
guidata(hObject, handles);

% UIWAIT makes Measurement wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Measurement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function heightEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to heightEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of heightEditBox as text
%        str2double(get(hObject,'String')) returns contents of heightEditBox as a double


% --- Executes during object creation, after setting all properties.
function heightEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to heightEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
   handles.board.flush();
   handles.board.delete();
catch
end
