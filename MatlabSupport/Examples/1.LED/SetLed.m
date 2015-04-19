% SetLed.m demo example.
%
% Description:
% This example shows Engduino LED 'setLed' function call. Function requires
% one input value, representing state of the small green colour LED on the
% Engduino board.
%
% July 2014, Engduino team: support@engduino.org
 
% clear all variables and objects 
clear all; close all;
 
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
e = engduino('COM1');

% turn on LED
e.setLed(1);

% wait for 1 second
pause(1);

% turn off LED
e.setLed(0);
