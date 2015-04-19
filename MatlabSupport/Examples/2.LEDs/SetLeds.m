% SetLeds.m demo example.
%
% Description:
% This example shows Engduino LEDs 'setLeds' function call. Function requires
% input vector length 16, representing colour of each RGB LED on the
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
 
% Function 'setLeds' takes vector of 16 values between [0-7]. Colours are
% defined in engduino object as:
%     COLOR_RED =     0
%     COLOR_GREEN =   1
%     COLOR_BLUE =    2
%     COLOR_YELLOW =  3
%     COLOR_MAGENTA = 4
%     COLOR_CYA =     5
%     COLOR_WHITE =   6
%     COLOR_OFF =     7
e.setLeds([e.COLOR_RED, e.COLOR_GREEN, e.COLOR_BLUE, e.COLOR_YELLOW, ...
           e.COLOR_MAGENTA, e.COLOR_CYA, e.COLOR_WHITE, e.COLOR_OFF, ...
           e.COLOR_RED, e.COLOR_GREEN, e.COLOR_BLUE, e.COLOR_YELLOW, ...
           e.COLOR_MAGENTA, e.COLOR_CYA, e.COLOR_WHITE, e.COLOR_OFF]);