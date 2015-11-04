%% SetLed.m demo example.
%
% Description:
% This example shows Engduino LED 'setLed' function call. Function requires
% one input value, which it represent the state of the small green colour LED on the
% Engduino board.
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
    e = engduino('COM4');
end

frequency = 10;
%% Main 
while(1)
    accReading = e.getAccelerometer();
    disp('Accelerometer reading in X Y Z');
    disp(accReading);
    pause(1/frequency);
end