% PulseSensor.m demo example.
%
% Description:
% This example shows analog output from LED-based pulse sensor. Analog
% input is pin 2 on the Engduino board. Reading is done by reading analog
% value through Engduino's protocol.
%
% TODO:
% - add average graph
% - add peak detection
% - add small blinking heart (maybe from polygons if that will be the
% easiest way).
% - change all labels
%
% May 2015, Engduino team: support@engduino.org
 
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

%% Initialize variables
% Set reading frequency [Hz] - readings per second.
frequency = 75;
 
% Set circle buffer length [samples]
buffSize = 100;
 
i = 1;
circBuff = nan(2, 4);
time = repmat(now, 2, 4);
t0 = now;
 
%% Set up the figure. 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Temperature', ...
                      'Visible', 'off');
 
% Set axes.
axesHandle = axes('Parent', figureHandle, 'YGrid', 'on', 'XGrid', 'on');
 
 
hold on;
plotHandle = plot(axesHandle, time, circBuff, ...
                                             'LineWidth', 2);
% Create xlabel.
xlabel('Time [s]', 'FontSize', 12);
 
% Create ylabel.
ylabel('Temperature [�C]', 'FontSize', 12);
 
% Create title.
title('Engduino temperature sensor', 'FontSize', 14);
 
% Create legend.
%legend('Temperature')
 
%% Real-time plot
set(figureHandle, 'Visible', 'on');
 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition(circBuff, e, true)
    % Read temperature from Engduino's temperature sensor.
    %newest = e.getTemperature();
    newest = e.analogRead(3);
    newest = newest(2);
 
    if i < buffSize
        % Add the newest sample into the buffer.
        circBuff(i, :) = newest;
        time(i, :) = repmat((now - t0)*10e4, 1, 4);
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end, :); repmat(newest, 1, 4)];
        time = [time(2:end, :); repmat((now - t0)*10e4, 1, 4)];
    end
    
    % Set xlim and ylim for Plot.
    % Set xlim and ylim for Plot.
    xlim(axesHandle, [min(time(:,1)) max(time(:,1))+10e-9]);
    ymin = min(circBuff(:, 1));
    ymax = max(circBuff(:, 1))+10e-9;
    span = (ymax - ymin)*0.1;
    ylim(axesHandle, [ymin - span, ymax + span]);
    
    % Plot data.
    set(plotHandle(1), 'YData', circBuff(:, 1), 'XData', time(:, 1));
    set(plotHandle(2), 'YData', smooth(circBuff(:, 1), 10), 'XData', time(:, 1));


    
    % Pause for one time interval.
    pause(1/frequency);
    
    % Increment counter.
    i = i + 1;
end