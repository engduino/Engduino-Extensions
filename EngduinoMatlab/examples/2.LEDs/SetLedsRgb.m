%% SetLeds.m demo example.
%
% Description:
% This example shows Engduino LEDs 'setLeds' function call. Function requires
% input vector length 16, representing colour of each RGB LED on the
% Engduino board.
%
% July 2015, MathWorks & Engduino team: support@engduino.org
 
% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
    % Create Engduino object and open COM port. You do not need to select
    % an active COM port, as it should be detected automatically. However,
    % in the case of unsuccessful connection, you may initialize Engduino
    % object with passing the active COM port. E.g. e = engduino('COM8');
    % To open the 'Bluetooth' port you need to initialize the Engduino
    % object with the 'Bluetooth' keyword and your Bluetooth device name.
    % E.g. e = engduino('Bluetooth', 'HC-05'); Demo mode can be enabled by
    % initialize the Engduino object with 'demo' keyword. E.g. e =
    % engduino('demo');
    e = engduino();
end
 
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

e.setLedsRgb([15,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;1,0,0;15,15,15;]);
%e.setLedsB([0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7,],[1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
