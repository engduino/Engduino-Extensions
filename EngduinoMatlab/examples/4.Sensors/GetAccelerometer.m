%% GetAccelerometer.m demo example.
%
% Description:
% This example shows Engduino Sensors 'getAccelerometer' function call. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
%
% July 2014, Engduino team: support@engduino.org
 

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
    e = engduino('COM10');
end
% Set reading frequency [Hz] - readings per second.
frequency = 10;
 
% Set circle buffer length [samples].
buffSize = 100;

% Plot range [G].
plotRange = 2;
 
i = 1;
circBuff = nan(2, 4);
time = repmat(now, 2, 4);
t0 = now;
 
%% Set up the figure. 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Accelerometer', ...
                      'Visible', 'off');
 
% Set axes.
axesHandle = axes('Parent', figureHandle, 'YGrid', 'on', 'XGrid', 'on');
 
 
hold on;
plotHandle = plot(axesHandle, time, circBuff,'Marker', 'o', ....
                                             'MarkerSize', 5, ...
                                             'LineWidth', 2);
% Create xlabel.
xlabel('Time [s]', 'FontSize', 12);
 
% Create ylabel.
ylabel('Acceleration [G]', 'FontSize', 12);
 
% Create title.
title('Engduino accelerometer sensor', 'FontSize', 14);
 
% Create legend.
legend({'Acc X', 'Acc Y', 'Acc Z', 'Sum'})
 
%% Real-time plot.
set(figureHandle, 'Visible', 'on');
 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')

% Main Loop
while ExitCondition(circBuff, e, true)
    % Read acceleration vector from Engduino's accelerometer sensor.
    newest = e.getAccelerometer();
    
    a = e.getSensors(10);
    
    % Add norm of the acceleration vector.
    newest = [newest, norm(newest)];
 
    if i < buffSize
        % Add the newest sample into the buffer.
        circBuff(i, :) = newest;
        time(i, :) = repmat((now - t0)*10e4, 1, 4);
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end, :); newest];
        time = [time(2:end, :); repmat((now - t0)*10e4, 1, 4)];
    end
    
    % Set xlim and ylim for Plot.
    xlim(axesHandle, [min(time(:,1)) max(time(:,1))+10e-9]);
    ylim(axesHandle, [-plotRange, plotRange]);
    
    % Plot data.
    for j=1:4
        set(plotHandle(j), 'YData', circBuff(:, j), 'XData', time(:, j));
    end

    % Pause for one time interval.
    pause(1/frequency);
    
    % Increment counter.
    i = i + 1;
end