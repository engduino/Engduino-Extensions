%% SetLedOnOff.m demo example.
%
% Description:
% This example shows how to turn on and off an LED using the setLedsOne
% function call. The function requires first parameter as an integer
% indication the position of LED and the second variable as the colour
%
% July 2015, Mathworks & Engduino team: support@engduino.org

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
% Set Engduino LED on position 0 to red colour and turn off after 3s.
e.setLedsOne(0,e.COLOR_RED);

% delay 3s
pause(3);

% Turn off LED
e.setLedsOne(0,e.COLOR_OFF);
