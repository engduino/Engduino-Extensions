%% PulseSensor.m demo example.
%
% Description:
% This example shows analog output from LED-based pulse sensor. Analog
% input is pin 3 on the Engduino board (first pin on the Engduino's
% extension header (AI_0)). Reading is done by reading analog value through
% Engduino's protocol.
%
% May 2015, Engduino team: support@engduino.org
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

% Set reading frequency [Hz] - readings per second.
frequency = 100;
 
% Set circle buffer length [samples]
buffSize = 100;

% Mean time between two beats (seconds)
mtbb = 0.5; % 120 beats per second (-> 60/mtbb)

% Initialize variables
tic
i = 1;
circBuff = nan(2, 3);
time = repmat(toc, 2, 3);
t0 = toc;
threshold = 50;
newest_lpf = 2^9;
last_peak = 0;
pulse = -1;
 
%% Set up the figure. 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Temperature', ...
                      'Visible', 'off', ...
                      'Position', [100, 100, 1000, 600]);
 
% Set axes.
axesHandle = axes('Parent', figureHandle, 'YGrid', 'on', 'XGrid', 'on');
 
 
hold on;
plotHandle = plot(axesHandle, time, circBuff, 'LineWidth', 2);

% Peak detection graphic
plotHandle(3).Color = [1, .2, .2];
plotHandle(3).Marker = '.';
plotHandle(3).MarkerSize = 50;

% Create xlabel.
xlabel('Time [s]', 'FontSize', 12);
 
% Create ylabel.
ylabel('Sensor output', 'FontSize', 12);
 
% Create title.
title('Sensor output', 'FontSize', 14);
 
% Create legend.
legend({'RAW data', 'LPF data', 'Beats'})
 
%% Real-time plot
% Execute loop until exit condition is met.
set(figureHandle, 'Visible', 'on');
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition(circBuff, e, true)
    
    % Read analog value from pin 3.
    newest = e.analogRead(3);
    newest = newest(2);

    % Lowpass filter
    % Higher value of alpha (a) will follow into less filtered signal.
    a = 0.2;
    newest_lpf  = (1-a)*newest_lpf + a*newest; 
    
    % Detect pulse
    if(newest > (newest_lpf + threshold) && (toc - last_peak) > mtbb)
        pulse = newest;
        last_peak = toc;
    end
    
    % Find peak
    if(pulse > 0 && newest > pulse)
        pulse = newest;
    elseif(pulse > 0 && newest < pulse)
        circBuff(end, 3) = pulse;
        pulse = -1;
    end
    
    % Add the newest sample into the buffer.
    if (i < buffSize)
        circBuff(i, :) = [newest, newest_lpf, nan];
        time(i, :) = repmat(toc, 1, 3);
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end, :); [newest, newest_lpf, nan]];
        time = [time(2:end, :); repmat(toc, 1, 3)];
    end
    

    % Set xlim and ylim for Plot.
    if (~isvalid(axesHandle)), return; end;
    xlim(axesHandle, [min(time(:,1)) max(time(:,1))+10e-9]);
    ymin = min(circBuff(:, 1));
    ymax = max(circBuff(:, 1))+10e-9;
    span = (ymax - ymin)*0.1;
    ylim(axesHandle, [ymin - span, ymax + span]);
    
    % Adjust threshold depends on a signal scale. 
    th_length = floor(buffSize/3);
    if (i > th_length)
        threshold = (max(circBuff(end-th_length:end, 1)) ... 
            - min(circBuff(end-th_length:end, 1)))/3;
        threshold = max(20, threshold); % Keep threshold above certain level.
    end
    
    % Plot data.
    set(plotHandle(1), 'YData', circBuff(:, 1), 'XData', time(:, 1));
    set(plotHandle(2), 'YData', circBuff(:, 2), 'XData', time(:, 1));
    set(plotHandle(3), 'YData', circBuff(:, 3), 'XData', time(:, 1));
    
    % Calculate heart rate as beats per second. We use mean value from
    % beats detected in circular buffer. The 'trimmean' function is used to
    % minimize efect of outliners.
    t = time(~isnan(circBuff(:, 3)), 1);
    dt = (t(2:end) - t(1:end-1))*60;
    bps = trimmean(dt, 50);
    bps_std = std(dt(dt < bps*1.3 & dt > bps*0.7));
    
    % Print result in plot's title.
    title(['Heart rate: ' num2str(floor(bps)) ' bps   -   Diviation: ' ... 
        num2str(bps_std) ' bps']);

    % Pause for one time interval.
    pause(1/frequency);
    
    % Increment counter.
    i = i + 1;
end