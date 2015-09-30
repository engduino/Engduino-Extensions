%% Button.m demo example.
%
% Description:
% This example shows Engduino 'getButton' function call. Function returns
% true when the button on the Engduino board is pressed, otherwise false.
%
% Push the button to turn on the small green LED on the Engduino
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

%% Main Loop
while (true)
    % read the status of the button
    if e.getButton()
        % turn on LED
        e.setLed(1);
    else 
        % turn off LED
         e.setLed(0);
    end
end
