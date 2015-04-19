function varargout = engduino_gui(varargin)
% engduino_gui MATLAB code for engduino_gui.fig
%      engduino_gui, by itself, creates a new engduino_gui or raises the existing
%      singleton*.
%
%      H = engduino_gui returns the handle to a new engduino_gui or the handle to
%      the existing singleton*.
%
%      engduino_gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in engduino_gui.M with the given input arguments.
%
%      engduino_gui('Property','Value',...) creates a new engduino_gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before engduino_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to engduino_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above untitleduntitledtext to modify the response to help engduino_gui

% Last Modified by GUIDE v2.5 29-Sep-2014 11:41:31

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
end

% --- Executes just before engduino_gui is made visible.
function engduino_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to engduino_gui (see VARARGIN)

    % Choose default command line output for engduino_gui
    handles.output = hObject;
    
    % Update handles structure
    guidata(hObject, handles);
    
    init(hObject);
end

function init(hObject)
    handles = guidata(hObject);
    handles.board = [];
    [handles.get_led_f, handles.set_led_f] = f_box();
    [handles.get_draw_f, handles.set_draw_f] = f_box();
    handles.set_led_f(@led_off);
    guidata(hObject, handles);
end

function connect_board(hObject)
    handles = guidata(hObject);
    handles.set_draw_f(makef_draw_all(handles));
    update = @(s) set(handles.board_text, 'string', s);

    cons = @() engduino(get(handles.board_port, 'string'));
    
    try
        if (~ isempty(handles.board))
            delete(handles.board);
        end
        handles.board = cons();
        
        handles.board.callback_sensors = @(temp, accel, mag, light, samples) ...
            sensors_callback(handles, temp, accel, mag, light, samples);
        
        handles.board.callback_button = @(temp, state) ...
            button_callback(handles, state);
        
        guidata(hObject, handles);
    catch e
        disp(e.message);
        update('Error');
    end
end

function fig = vect_init(ax, range)
    fig = quiver3(ax, 0, 0, 0, 0, 0, 1);
    drawnow();
    axis(ax, [-range range -range range -range range]);
    axis(ax, 'manual');
end

function fig = scal_init(ax, y_range_min, y_range_max, window_size)
    fig = plot(ax, [1 : window_size], ...
               [y_range_min zeros(1, window_size - 2) y_range_max], ...
               'linewidth', 2);
    drawnow();
    axis(ax, 'manual');
    grid on;
end

function f = makef_draw_all(handles)
    makef_draw = @(fig, draw_f) @(values) draw_f(values);
    makef_vect_draw = @(fig) @(vec) ...
        set(fig, 'udata', vec(1), 'vdata', vec(2), 'wdata', vec(3));
    makef_scal_draw = @(fig) @(values) ...
        set(fig, 'xdata', [1 : numel(values)], 'ydata', fliplr(values));
    
    nr_samples = get_nr_samples(handles);
    draw_accel = makef_vect_draw(vect_init(handles.accel_ax, 1.2));
    draw_mag = makef_vect_draw(vect_init(handles.mag_ax, 1200));
    draw_light = makef_scal_draw(scal_init(handles.light_ax, 0, 1023, nr_samples));
    draw_temp = makef_scal_draw(scal_init(handles.temp_ax, 15, 40, nr_samples));
    function draw(temp, accel, mag, light)
        draw_accel(accel);
        draw_mag(mag);
        draw_light(light);
        draw_temp(temp);
        drawnow();
    end

    f = @(temp, accel, mag, light) draw(temp, accel, mag, light);
end

function ret_v = append_v(vec, val, nr_samples)
    if (isempty(vec))
        vec = [vec];
    end
    ret_v = [vec(:, 2:end) val zeros(size(val, 1), nr_samples - numel(vec) - 1)];
    len_v = numel(ret_v);
    if (len_v > nr_samples)
        ret_v = ret_v(:, end - nr_samples + 1 : end);
    end
end

function sensors_callback(handles, temp, accel, mag, light, samples)
    nr_samples = get_nr_samples(handles);
    
    % Holds a vector of samples over time.
    persistent light_v;
    persistent temp_v;
    light_v = append_v(light_v, light, nr_samples);
    temp_v = append_v(temp_v, temp, nr_samples);
    
    led_f = handles.get_led_f();
    draw_f = handles.get_draw_f();
    draw_f(temp_v, accel, mag, light_v);
    led_f(handles.board, temp_v, accel, mag, light_v);
end

function button_callback(handles, state)
    % Called on button change

end

function val = get_nr_samples(handles)
    val = floor(get(handles.fs_slider, 'value') ...
          * floor(get(handles.window_slider, 'value')));
end

function reset_leds(board)
    board.leds_r(:) = 0;
    board.leds_g(:) = 0;
    board.leds_b(:) = 0;
end

function led_off(board, temp_v, accel, mag, light_v)
    reset_leds(board);
end

function led_grad_accel(board, temp_v, accel, mag, light_v)
    persistent accel_v;
    accel_v = append_v(accel_v, accel', 5);
    
    avg = mean(mean(abs(gradient(accel_v))));

    bright = min(15, floor(avg * 15));
    board.leds_r(:) =  bright;
end

function led_light(board, temp_v, accel, mag, light_v)
    avg = mean(light_v(end - 5 : end));
    bright = min(15, floor(avg/68));
    
    board.leds_r(:) = bright;
    board.leds_g(:) = bright;
    board.leds_b(:) = bright;
end

function led_shake(board, temp_v, accel, mag, light_v)
    persistent accel_v;
    accel_v = append_v(accel_v, accel', 5);
    
    avg = mean(mean(abs(gradient(accel_v))));
    shake_count = min(15, floor(avg * 15));
    
    board.leds_r(randi([1, board.LED_COUNT], 1, shake_count)) = ...
        randi([0, 15], 1, shake_count);
    board.leds_g(randi([1, board.LED_COUNT], 1, shake_count)) = ...
        randi([0, 15], 1, shake_count);
    board.leds_b(randi([1, board.LED_COUNT], 1, shake_count)) = ...
        randi([0, 15], 1, shake_count);
end

function led_glow(board, temp_v, accel, mag, light_v)
    r = board.leds_r(1);
    g = board.leds_g(1);
    b = board.leds_b(1);
    
    r = r + 1;
    if r > 15
        r = 0;
        g = g + 1;
    end
    if g > 15
        g = 0;
        b = b + 1;
    end
    
    board.leds_r(:) = r;
    board.leds_g(:) = g;
    board.leds_b(:) = b;
end

function led_train(board, temp_v, accel, mag, light_v)
    if (isequal(board.leds_r, zeros(1, board.LED_COUNT)))
        board.leds_r(1) = 7;
        board.leds_g(2) = 7;
        board.leds_b(3) = 7;
    end
    
    avg = mean(gradient(temp_v(end - 2 : end)));
    board.leds_r = circshift(board.leds_r', sign(avg))';
    board.leds_g = circshift(board.leds_g', sign(avg))';
    board.leds_b = circshift(board.leds_b', sign(avg))';
end

% --- Outputs from this function are returned to the command line.
function varargout = engduino_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in board_button.
function board_button_Callback(hObject, eventdata, handles)
% hObject    handle to board_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    connect_board(hObject);
end

% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    try
        handles.board.callbackEnable = false;
        handles.board.getSensors(-1);
        pause(0.1);
        handles.board.flush();
        handles.board.delete();
    catch
    end
end

% --- Executes during object creation, after setting all properties.
function accel_ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to accel_ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate accel_ax
end

% --- Executes during object creation, after setting all properties.
function mag_ax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mag_ax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
train(f(temp))
% Hint: place code in OpeningFcn to populate mag_ax
end


% --- Executes when selected object is changed in uipanel9.
function uipanel9_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel9 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
    name = get(eventdata.NewValue, 'string');
    reset_leds(handles.board);
    
    switch lower(name)
        case 'off'
            handles.set_led_f(@led_off);
        case 'bright=f(grad(accel))'
            handles.set_led_f(@led_grad_accel);
        case 'bright=f(light)'
            handles.set_led_f(@led_light);
        case 'shake (f(grad(accel)))'
            handles.set_led_f(@led_shake);
        case 'glow'
            handles.set_led_f(@led_glow);
        case 'train (f(temp))'
            handles.set_led_f(@led_train);
    end
end


% --- Executes on slider movement.
function fs_slider_Callback(hObject, eventdata, handles)
% hObject    handle to fs_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.board.callbackEnable = false;
    set(handles.fs_edit, 'string', ...
        sprintf('%.2f Hz', get(hObject, 'value')));
    handles.board.getSensors(floor(1000 * (1 / get(hObject, 'value'))));
    pause(0.1);
    handles.set_draw_f(makef_draw_all(handles));
    handles.board.callbackEnable = true;
end

% --- Executes during object creation, after setting all properties.
function fs_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]); 
    end
end



function fs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs_edit as text
%        str2double(get(hObject,'String')) returns contents of fs_edit as a double
end

% --- Executes during object creation, after setting all properties.
function fs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on slider movement.
function window_slider_Callback(hObject, eventdata, handles)
% hObject    handle to window_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    handles.board.callbackEnable = false;
    set(handles.window_edit, 'string', ...
        sprintf('%d s', floor(get(hObject, 'value'))));
    pause(0.1);
    handles.set_draw_f(makef_draw_all(handles));
    handles.board.callbackEnable = true;
end

% --- Executes during object creation, after setting all properties.
function window_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
    if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor',[.9 .9 .9]);
    end
end


function window_edit_Callback(hObject, eventdata, handles)
% hObject    handle to window_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of window_edit as text
%        str2double(get(hObject,'String')) returns contents of window_edit as a double
end

% --- Executes during object creation, after setting all properties.
function window_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to window_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end

% --- Executes during object creation, after setting all properties.
function board_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to board_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end



function board_port_Callback(hObject, eventdata, handles)
% hObject    handle to board_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of board_port as text
%        str2double(get(hObject,'String')) returns contents of board_port as a double
end
