%% Blink.m demo example.
%
% Description:
% Turns on small green colour LED on the Engduino board for a specified
% amount of time, then off for the same period, repeatedly.
%
% July 2014, Engduino team: support@engduino.org
%

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

% Blinking delay (seconds)
delay = 0.5;

%% Main loop
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition([], e, true)
    
    e.setLed(1);    % Turn on LED
    pause(delay);   % Pause for a specified amount of time
    e.setLed(0);    % Turn off LED
    pause(delay);   % Pause for a specified amount of time
end