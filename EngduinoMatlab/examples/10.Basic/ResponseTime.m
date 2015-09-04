%% ResponseTime.m demo example.
%
% Description: 
% This example measures user's response time multiple times and plots a
% histogram of them after termination. User needs to press a button one the
% Engduino board as fastest as possible after the LEDs turn on. Random
% intevals between blinks can be set under the initialization part of this
% example. Response time is measured multiple times - until a user will not
% terminate the execution by pressing 'ESC' or 'q' key on a keyboard.
% Finally, all response times are plotted in one histogram, showing their
% distribution.
%
% June 2015, Engduino team: support@engduino.org
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
frequency = 100;
 
% Set random delay range
delay_min = 0.5;    % Absolute minimum delay between two blinks (seconds).
delay_window = 1.5; % Random delay window (seconds).
 
% Initialize array
response_times = [];
 
% Get the first blink event
tic
timestamp = -1;
nexttime = rand()*delay_window + delay_min;
 
%% Main loop
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
 
while ExitCondition([], e, false)
    
    % If we are ready for the next round, then turn on LEDs and start 
    % measuring time.
    if(toc > nexttime && timestamp < 0)
        e.setLedsAllB(e.COLOR_RED, 5);
        timestamp = toc;
    end
    
    % Catch button press and measure time spent between blink and response.
    if (timestamp > 0 && e.getButton())
        dt = toc - timestamp;
        if (dt < 1)
            % Save the result in the array and show it in a terminal window.
            response_times = [response_times; dt];
            disp(['Response time: ' num2str(dt) 's'])
        else
            % Don't save the result, if you are too slow. 
            disp('Too slow!')
        end
        
        % Turn off LEDs and randomize the next blink event based on
        % predefined random delay settings.
        timestamp = -1;
        e.setLedsAll(e.COLOR_OFF);
        nexttime = toc + rand()*delay_window + delay_min;
    end
    
    % If a user press the button before blink event, extend it for another
    % random interval, to avoid continues pressing.
    if (e.getButton())
        nexttime = nexttime + rand()*delay_min;
    end
 
    % Pause for one-time interval.
    pause(1/frequency);
end
 
%% Plot the results
% Plot histogram of all catched response times.
hist(response_times, 10);
grid on;
title(['Histogram of ' num2str(length(response_times)) ' response times'])
xlabel('Delay (s)');
ylabel('Distribution')
