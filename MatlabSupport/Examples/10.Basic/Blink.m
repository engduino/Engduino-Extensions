% Blink.m demo example.
%
% Description:
% Turns on small green colour LED on the Engduino board for one second, 
% then off for one second, repeatedly.
%
% July 2014, Engduino team: support@engduino.org
 
% clear all variables and objects 
clear all; close all;
 
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
e = engduino('COM1');
 
% execute loop until 'ESC' or 'q' is pressed
disp('Press ''ESC'' or ''q'' to terminate execution...')
while ExitCondition()
    e.setLed(1);
    pause(1);
    e.setLed(0);
    pause(1);
end