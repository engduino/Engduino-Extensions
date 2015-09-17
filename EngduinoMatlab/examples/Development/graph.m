%% EstimateDistanceIntegration.m demo example.
%
% This example uses the accelerometer to estimate distance travelled. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
% We only use x-axis on the accelerometer for calculation. Make sure
% that the Engduino device is placed with the LEDs facing downwards. Upload
% the code, position the accelerometer, press the button to start and press the
% button to stop the calculation immediately.
%
% July 2015, Engduino team: support@engduino.org
 
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
    e = engduino('Bluetooth','HC-05');
end

% Set reading frequency [Hz] - readings per second.
frequency = 100;

% Set multiplier to convert accelerometer data to acceleration m/s^2
multiplier = 26;

% Set threshold to ignore small noise in acceleration
acc_threshold = 0.5
vel_threshold = 0.3;

% Initialise variables for calculation
previous_time =0;
previous_velocity =0;
total_displacement = 0;
current_velocity = 0;

% filter
gxFilt = 0;
accFilt =0;
velFilt =0;

% filter control coefficient
alpha = 0.5;
beta = 0.9;
gamma = 0.9;

current_time = repmat(now, 2, 4);
t0 = now;

pause(1);

% Wait to start calculation
while(not(e.getButton()))
    pause(0.1);
end

%% Initialise accelerometer reading
for i=1:10
    newReading = e.getAccelerometer();
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    % high pass filter accelerometer output
    gxFilt_filt = gx - ((1-alpha)*gxFilt + alpha*gx);
end

% accelerometer data is multiplied to get 1g=10m/s^2
init_accx = (floor(gxFilt*100)*multiplier/100); 


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
                      'Name', 'Velocity over Time', ...
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
ylabel('Velocity (m/s)', 'FontSize', 12);
 
% Create title.
title('Velocity over Time', 'FontSize', 14);
 
% Create legend.
legend({'Velocity'})
 
%% Real-time plot.
set(figureHandle, 'Visible', 'on');




%% Main Program loop
while (not(e.getButton()))
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    % high pass filter accelerometer output
    gxFilt = gx - ((1-alpha)*gxFilt + alpha*gx);
    
    acceleration = (floor(gxFilt*100)*multiplier/100 - init_accx);
    
    accFilt = (1-beta)*accFilt + beta*acceleration;
    % ignore small value acceleration due to noise
    if(accFilt>-acc_threshold&&accFilt<acc_threshold)
        accFilt = 0;
    end
    
    current_time = repmat((now - t0)*10e4,1,1);
    
    x=sym(accFilt);
    
    % Integration from acceleration to velocity to displacement
    current_velocity = previous_velocity + int(x, previous_time, current_time);
    
    % low pass filter to filter out noise from calculated velocity
    velFilt = (1-gamma)*velFilt + gamma*current_velocity;

    % double integration from accelerometer to displacement
    displacement = int(previous_velocity + int(x, previous_time, current_time), previous_time, current_time);
    
    total_displacement = total_displacement + displacement;
    previous_velocity = velFilt;
    
    previous_time = current_time;

    if i < buffSize
        % Add the newest sample into the buffer.
        circBuff(i, :) = current_velocity;
        time(i, :) = repmat((now - t0)*10e4, 1, 4);
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        circBuff = [circBuff(2:end, :); current_velocity];
        time = [time(2:end, :); repmat((now - t0)*10e4, 1, 4)];
    end
    
    % Set xlim and ylim for Plot.
    xlim(axesHandle, [min(time(:,1)) max(time(:,1))+10e-9]);
    ylim(axesHandle, [-plotRange, plotRange]);
    disp(time);
    % Plot data.
    for j=1:4
        set(plotHandle(j), 'YData', circBuff(:, j), 'XData', time(:, j), 'Color','blue');
    end
    % Pause for one time interval.
    pause(1/frequency);
    % Increment counter.
    i = i + 1;
end