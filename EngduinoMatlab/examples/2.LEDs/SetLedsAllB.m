%% SetLedsAllB.m demo example.
%
% Description:
% This example shows Engduino LEDs 'setLedsAllB' function call. Function takes
% the colour and the brightness level
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
    e = engduino('Bluetooth', 'HC-05');
end

%% Main
% Set one colour and brightness for all the 16 LEDs on Engduino
 
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
%
% Brightness level 0-15

e.setLedsAllB(e.COLOR_RED,1);
