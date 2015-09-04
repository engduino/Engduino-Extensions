%% Level.m demo example.
%
% Description:
% Show a red LED on one side if we're low on that side show nothing if
% we're high, and show green on both sides if it's level(ish)
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
 
% Set initial LEDs state
e.setLedsAll(e.COLOR_OFF);
 
% Set frequency [Hz]. Readings per second.
frequency = 10;

% Set Threshold. Lower the threshold is, more difficult is to balance the
% board and get four green lights.
threshold = 0.02;
 
%% Main loop
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')

while ExitCondition([], e, true)

    % Read the acceleration vector
    acc = e.getAccelerometer();
    
    % And light the appropriate LEDs depending on whether we're level
    % or not. The LEDs chosen are on opposite sides of the board.
    if((acc(1) > 0 && acc(1) < threshold) || (acc(1) < 0 && acc(1) > -threshold))
        e.setLedsOne(12, e.COLOR_GREEN);
        e.setLedsOne(4, e.COLOR_GREEN);
    elseif(acc(1) > 0.02) 
        e.setLedsOne(12, e.COLOR_RED);
        e.setLedsOne(4,  e.COLOR_OFF);
    else
        e.setLedsOne(12, e.COLOR_OFF);
        e.setLedsOne(4,  e.COLOR_RED);
    end
    
    if((acc(2) > 0 && acc(2) < threshold) || (acc(2) < 0 && acc(2) > -threshold))
        e.setLedsOne(9,  e.COLOR_GREEN);
        e.setLedsOne(15, e.COLOR_GREEN);
    elseif(acc(2) > 0.02) 
        e.setLedsOne(9,  e.COLOR_RED);
        e.setLedsOne(15, e.COLOR_OFF);
    else
        e.setLedsOne(9,  e.COLOR_OFF);
        e.setLedsOne(15, e.COLOR_RED);
    end
    
    % Pause for one time interval.
    pause(1/frequency);
end