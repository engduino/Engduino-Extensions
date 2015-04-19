% Level.m demo example.
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
% Set frequency [Hz]. Steps per second.
frequency = 10;

e.setLedsAll(e.COLOR_OFF);
 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition([], e, true)

    % Read the acceleration vector
    acc = e.getAccelerometer();
    
    % And light the appropriate LEDs depending on whether we're level
    % or not. The LEDs chosen are on opposite sides of the board.
    if((acc(1) > 0 && acc(1) < 0.02) || (acc(1) < 0 && acc(1) > -0.02))
        e.setLedsOne(12, e.COLOR_GREEN);
        e.setLedsOne(4, e.COLOR_GREEN);
    elseif(acc(1) > 0.02) 
        e.setLedsOne(12, e.COLOR_RED);
        e.setLedsOne(4,  e.COLOR_OFF);
    else
        e.setLedsOne(12, e.COLOR_OFF);
        e.setLedsOne(4,  e.COLOR_RED);
    end
    
    if((acc(2) > 0 && acc(2) < 0.02) || (acc(2) < 0 && acc(2) > -0.02))
        e.setLedsOne(9,  e.COLOR_GREEN);
        e.setLedsOne(15, e.COLOR_GREEN);
    elseif(acc(2) > 0.02) 
        e.setLedsOne(9,  e.COLOR_RED);
        e.setLedsOne(15, e.COLOR_OFF);
    else
        e.setLedsOne(9,  e.COLOR_OFF);
        e.setLedsOne(15, e.COLOR_RED);
    end
    
    % Pause for one time interval.
    pause(1/frequency);
end