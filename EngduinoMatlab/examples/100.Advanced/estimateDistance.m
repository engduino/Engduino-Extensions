%% EstimateDistance.m demo example.
%
% Description:
% This example uses the accelerometer to estimate distance traveled. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
% This example only uses x-axis on accelerometer for calculation. Upload
% the code, position the Engduino with the LED facing downwards, press the 
% button to start measuring, move the engduino along the straight you wish 
% to measure, press the button again when you have reached the end of your 
% measurement to stop measuring.
%
% July 2015, MathWorks & Engduino team: support@engduino.org

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
multiplier = 30;
% Set threshold to ignore small noise in acceleration
acc_threshold = 0.5;

% initialise filtered value to 0
xAcc_Filtered = 0;
acceleration_Filtered =0;
velocity_Filtered =0;
gx = 0;

% coefficient to apply filtering
alpha = 0.5;
beta = 0.9;
gamma = 0.9;

% initialise the time
current_time = repmat(now, 2, 4);
t0 = now;
previous_time =0;

% initialise variables used in calculation
previous_velocity =0;
displacement = 0;
total_displacement = 0;
current_velocity = 0;
init =0;

%% For Graph plotting
buffSize = 10;
accelerometer_circBuff = nan;
velocity_circBuff = nan;
time = now;
i=1;

figure;
% graph1
graph(1) = subplot(1,2,1);
plotHandle1 = plot(graph(1),time,accelerometer_circBuff,'Marker','o','MarkerSize',5,'LineWidth',2);
xlabel('Time[s]');
ylabel('Gravitational Force (g)');
title(['RAW Acceleration: ' char(vpa(gx)) 'g'], 'FontSize', 28);
limits = 1.0;
ylim([-limits limits])
axis square;
grid on

% graph2
graph(2) = subplot(1,2,2);
plotHandle2 = plot(graph(2),time,velocity_circBuff,'Marker','o','MarkerSize',5,'LineWidth',2);
xlabel('Time[s]');
ylabel('Velocity (m/s)');
limits = 1.0;
ylim([-limits limits]);
title(['Displacement: ' char(vpa(total_displacement,3)) 'm'],'FontSize', 28);
axis square;
grid on

%% Wait to start calculation
while(not(e.getButton()))
    pause(0.1);
end

pause(0.3);
%% initialise accelerometer reading
for i=1:5
    newReading = e.getAccelerometer();
    gx = newReading(1);
    % apply high pass filter to the accelerometer output
    xAcc_Filtered = gx - ((1-alpha)*xAcc_Filtered + alpha*gx);
end

% accelerometer data is multiplied to get 1g=10m/s^2
init_accx = (floor(xAcc_Filtered*100)*multiplier/100);


%% Main Program loop
while (not(e.getButton()))
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    gx = newReading(1);
    % apply high pass filter to the accelerometer output
    xAcc_Filtered = gx - ((1-alpha)*xAcc_Filtered + alpha*gx);

    % accelerometer data is multiplied to get 1g=10m/s^2
    acceleration = (floor(xAcc_Filtered*100)*multiplier/100 - init_accx);
    
    % apply low pass filter to acceleration result
    acceleration_Filtered = (1-beta)*acceleration_Filtered + beta*acceleration;
    
    % ignore small value acceleration due to noise
    if(acceleration_Filtered>-acc_threshold&&acceleration_Filtered<acc_threshold)
        acceleration_Filtered = 0;
    end
    
    % to get current time
    current_time = repmat((now - t0)*10e4,1,1);
    
    % dt = change in time
    if (init==0)
        dt=0;
        init=1;
    else
        dt = (current_time - previous_time);
    end
    % Integration from acceleration to velocity to displacement
    current_velocity = previous_velocity + acceleration_Filtered*dt;
    
    % apply low pass filter to velocity result
    velocity_Filtered = (1-gamma)*velocity_Filtered + gamma*current_velocity;
    
    displacement = previous_velocity*dt + 0.5*acceleration_Filtered*dt*dt;
    total_displacement = total_displacement + displacement;
    previous_velocity = velocity_Filtered;
    
    previous_time = current_time;


    %% Real time graph plotting
    if i < buffSize
        % Add the newest sample into the buffer.
        accelerometer_circBuff(i) = gx;
        velocity_circBuff(i) = velocity_Filtered;
        time(i) = (now-t0)*10e4;
    else
        % If we have enough samples then remove oldest sample and add the
        % newest one into the buffer.
        accelerometer_circBuff = [accelerometer_circBuff(2:end), gx];
        velocity_circBuff= [velocity_circBuff(2:end), velocity_Filtered];
        time = [time(2:end), (now - t0)*10e4];
    end
    % subplot raw X acceleration vector
    subplot(graph(1));
    limits = 1.0;
    xlim([min(time) max(time)+10e-9]);
    ylim([-limits limits]);
    title(['RAW Acceleration: ' char(vpa(gx)) 'g'], 'FontSize', 28);
    set(plotHandle1,'YData',accelerometer_circBuff,'XData',time);
    
    subplot(graph(2));
    limits = 1.0;
    xlim([min(time) max(time)+10e-9]);
    ylim([-limits limits]);
    title(['Displacement: ' num2str(total_displacement, 3) 'm'], 'FontSize', 28);
    set(plotHandle2,'YData',velocity_circBuff,'XData',time);
    
    i = i+1;
    % Pause for one time interval.
    pause(1/frequency);
end