%% SetLedsB.m demo example.
%
% Description:
% This example shows Engduino LEDs 'setLedsB' function call. Function takes
% an array of 16 variables each represent the colour correspond to the
% Engduino LED and another array of 16 variables each represent the
% corresponding LED brightness
%
% July 2015, MathWorks & Engduino team: support@engduino.org

%% Initialize variables

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

%% Main
% Set individual colours and brightness of the LEDs on Engduino

% Function 'setLedsB' takes vector of 16 values between [0-7]. Colours are
% defined in engduino object as:
%     COLOR_RED =     0
%     COLOR_GREEN =   1
%     COLOR_BLUE =    2
%     COLOR_YELLOW =  3
%     COLOR_MAGENTA = 4
%     COLOR_CYA =     5
%     COLOR_WHITE =   6
%     COLOR_OFF =     7
%
% Brightness level from 0-15

e.setLedsB([0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7],[1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);
