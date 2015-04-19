% RunningLeds.m demo example.
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
leds = [0, 1, 2];

% Set frequency [Hz]. Steps per second.
frequency = 5;
 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition([], e, true)

    e.setLedsExact(mod(leds, 16), [e.COLOR_RED, e.COLOR_GREEN, e.COLOR_BLUE]);
    leds = leds + [1,1,1];
    
    % Pause for one time interval.
    pause(1/frequency);
    
    frequency = frequency + 0.3;
    
    if(frequency > 100)
        frequency = 5;
    end
end