% GetTemperature.m demo example.
%
% Description:
% This example shows Engduino Sensors 'getTemperature' function call. 
% Function returns temperature value in degrees [°C].
%
% July 2014, Engduino team: support@engduino.org
 
% Clear all variables and objects 
clear all; close all;
 
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
% Set "port = demo" to enable demo run.
port = 'demo';
port = 'COM8';
e = engduino(port);

%% Initialize variables
% Set reading frequency [Hz] - readings per second.
frequency = 5;
 
% Set circle buffer length [samples]
buffSize = 100;
 
i = 1;
circBuff = nan;
time = now;
t0 = now;
 
%% Set up the figure. 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Temperature', ...
                      'Visible', 'off');
 
% Set axes.
axesHandle = axes('Parent', figureHandle, 'YGrid', 'on', 'XGrid', 'on');
 
 
hold on;
plotHandle = plot(axesHandle, time, circBuff,'Marker', 'o', ....
                                             'MarkerSize', 6, ...
                                             'MarkerEdgeColor', [0.3 0.7 1], ...
                                             'LineWidth', 2, ...
                                             'Color', [0 0 1]);
% Create xlabel.
xlabel('Time [s]', 'FontSize', 12);
 
% Create ylabel.
ylabel('Temperature [°C]', 'FontSize', 12);
 
% Create title.
title('Engduino temperature sensor', 'FontSize', 14);
 
% Create legend.
legend('Temperature')
 
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
    newest = e.getTemperature();
 
    if i < buffSize
        % Add the newest sample into the buffer.
        circBuff(i) = newest;
        time(i) = (now - t0)*10e4;
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end), newest];
        time = [time(2:end), (now - t0)*10e4];
    end
    
    % Set xlim and ylim for Plot.
    xlim(axesHandle, [min(time) max(time)+10e-9]);
    ymin = min(circBuff);
    ymax = max(circBuff)+10e-9;
    span = (ymax - ymin)*0.1;
    ylim(axesHandle, [ymin - span, ymax + span]);
    
    % Plot data.
    set(plotHandle, 'YData', circBuff, 'XData', time);
    
    % Pause for one time interval.
    pause(1/frequency);
    
    % Increment counter.
    i = i + 1;
end