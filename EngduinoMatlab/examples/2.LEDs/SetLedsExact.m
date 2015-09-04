%% SetLedsExact.m demo example.
%
% Description:
% This example shows Engduino LEDs 'setLedsExact' function call. Function
% set the colour of one LED with value range [0-15], other LEDs will be
% turned off.
%
% July 2015, Engduino team: support@engduino.org

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
% Set colour for exactly one LEDs on Engduino and turn off other LEDs 

% Function 'setLedsExact' select one LED in the range [0-15] and colours values between [0-7]. Colours are
% defined in engduino object as:
%     COLOR_RED =     0
%     COLOR_GREEN =   1
%     COLOR_BLUE =    2
%     COLOR_YELLOW =  3
%     COLOR_MAGENTA = 4
%     COLOR_CYA =     5
%     COLOR_WHITE =   6
%     COLOR_OFF =     7
e.setLedsExact(0,e.COLOR_GREEN);