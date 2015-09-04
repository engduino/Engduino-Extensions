%% AnalogRead.m demo example.
%
% Description:
% This example shows Engduino 'analogRead' function call. Function returns
% values of the analog pin.
%
% June 2015, Engduino team: support@engduino.org
 
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
    e = engduino('Bluetooth','HC-05');
end

%% Main Loop
while (true)
    % Get analog Reading
    pins = e.analogRead([1;2;3;]);
    pin1_val = pins(1,2)
    pin2_val = pins(2,2)
    pin3_val = pins(3,2)
end
