% LightLeds.m demo example.
%
% Description:
%
% July 2014, Engduino team: support@engduino.org
 
% Clear all variables and objects 
clear all; close all;
 
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
% Set "port = demo" to enable demo run.
port = 'COM16';
e = engduino(port);

%% Initialize variables
light = e.getLight();

% Set frequency [Hz]. Steps per second.
frequency = 10;
 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition([], e, true)

    % Lowpass filter
    light = 0.7*light + 0.3*e.getLight(); 
    
    % Turn on Leds
    leds = ones(1, 16).*e.COLOR_OFF;
    lval = floor(light/60);
    leds(1:lval) = ones(1, length(lval)).*e.COLOR_WHITE;
    e.setLeds(leds);
    
    % Pause for one time interval.
    pause(1/frequency);
end