%% Serial Communication
% This example code shows how to read data from serial port for those
% that contains value

serialPort = 'COM4';

%% Check for old serial port before creating new one
oldSerial = instrfind('Port','COM4');
if(~isempty(oldSerial))
   fclose(oldSerial);
   delete(oldSerial);
end

serialObject = serial(serialPort);
fopen(serialObject);

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
                      'Name', 'Sample Reading', ...
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
ylabel('Value', 'FontSize', 12); 
% Create title.
title('Readings', 'FontSize', 14);
% Create legend.
legend('Value')
%% Real-time plot
set(figureHandle, 'Visible', 'on'); 
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')

while (1)
        reading = fscanf(serialObject);  %#ok<SAGROW>
        temp_str = strsplit(reading,{'\r\n'},'DelimiterType','RegularExpression');
        val = str2double(temp_str(1));

        if i < buffSize
            % Add the newest sample into the buffer.
            circBuff(i) = val;
            time(i) = (now - t0)*10e4;
        else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
            circBuff = [circBuff(2:end), val];
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

%% Clean up the serial object
fclose(serialObject);
delete(serialObject);
clear serialObject;