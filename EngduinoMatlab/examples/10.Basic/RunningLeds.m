%% RunningLeds.m demo example.
%
% Description:
% The aim of this example is to show some of the methods of
% causing the LEDs to light. The first part of the code is where
% red, green and blue LEDs chase anti-clockwise around the Engduino,
% getting gradually faster until they blur into white.
%
% When going sufficiently fast, we display red green and blue on all
% LEDs. After that code rests back to initial state and repeat the 
% execution. 
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
    e = engduino('COM4');
end
 
% Set initial LEDs state
leds = [0, 1, 2];
 
% Set frequency [Hz]. Steps per second.
frequency = 5;
 
%% Main loop
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')

while ExitCondition([], e, true)
    
    % Update LEDs by sending command to the Engduino board.
    e.setLedsExact(mod(leds, 16), [e.COLOR_RED, e.COLOR_GREEN, e.COLOR_BLUE]);
    
    % Update internal 'leds' array holding current state of LEDs.
    leds = leds + [1, 1, 1];
    % Pause for one time interval.
    pause(1/frequency);
    
    % Speed-up a bit.
    frequency = frequency + 0.3;
    
    % Check if the frequency is too high.
    if(frequency > 100)
        % Reset the frequency variable
        frequency = 5;
        
        % Set all LEDs on red, green and blue colour for a short amount of 
        % time (500 milliseconds).  
        e.setLedsAll(e.COLOR_RED);
        pause(0.5);
        e.setLedsAll(e.COLOR_GREEN);
        pause(0.5);
        e.setLedsAll(e.COLOR_BLUE);
        pause(0.5);
        e.setLedsAll(e.COLOR_OFF);
    end
end