% MagnetometerCalibration.m demo example.
%
% Description:
% This example shows Engduino Sensors 'getTemperature' function call. 
% Function returns temperature value in degrees [°C].
%
% July 2014, Engduino team: support@engduino.org
 
% clear all variables and objects 
clear all; close all;
 
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
%e = engduino('COM49');
 
%% Initialize variables
% Set reading frequency [Hz]. Readings per second.
frequency = 10;
 
% Set circle buffer length [samples]
buffSize = 50;
 
i = 1;
circBuff = nan;
time = now;
t0 = now;
 
%% Set up the figure 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Temperature', ...
                      'Visible', 'off');

hold on;
% Subplots
p = zeros(1,2);
ph = zeros(1,2);

p(1) = subplot(2,1,1);
ph(1) = plot(p(1), time, circBuff, 'Marker', 'o', ....
                                             'MarkerSize', 6, ...
                                             'MarkerEdgeColor', [0.3 0.7 1], ...
                                             'LineWidth', 2, ...
                                             'Color', [0 0 1]);
set(p(1), 'YGrid', 'on', 'XGrid', 'on');
p(2) = subplot(2,1,2);
ph(2) = plot(p(2), time, circBuff,'Marker', 'o', ....
                                             'MarkerSize', 6, ...
                                             'MarkerEdgeColor', [0.3 0.7 1], ...
                                             'LineWidth', 2, ...
                                             'Color', [1 0 0]);
set(p(2), 'YGrid', 'on', 'XGrid', 'on');
                                         


% Create xlabel
xlabel('Time [s]', 'FontSize', 12);
 
% Create ylabel
ylabel('Temperature [°C]', 'FontSize', 12);
 
% Create title
title('Engduino temperature sensor', 'FontSize', 14);
 
% Create legend
legend('Temperature')
 
%% Real-time plot
set(figureHandle, 'Visible', 'on');
 
% execute loop until 'ESC' or 'q' is pressed
disp('Press ''ESC'' or ''q'' to terminate execution...')
while ExitCondition()
    % read temperature from Engduino's temperature sensor
    newest = randn();
 
    if i < buffSize
        % add the newest sample into the buffer
        circBuff(i) = newest;
        time(i) = (now - t0)*10e4;
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end), newest];
        time = [time(2:end), (now - t0)*10e4];
    end
    
    % set xlim and ylim for Plot
    xlim(p(1), [min(time) max(time)+10e-9]);
    ymin = min(circBuff);
    ymax = max(circBuff)+10e-9;
    span = (ymax - ymin)*0.1;
    ylim(p(1), [ymin - span, ymax + span]);
    
    % plot data
    set(ph(1), 'YData', circBuff, 'XData', time);
    
    set(ph(2), 'YData', circBuff.^2, 'XData', time);
    
    % pause for one time interval
    pause(1/frequency);
    
    % increment counter
    i = i + 1;
end