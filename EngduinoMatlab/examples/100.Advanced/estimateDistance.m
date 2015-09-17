%% EstimateDistance.m demo example.
%
% Description:
% This example uses the accelerometer to estimate distance travelled. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
% This example only uses x-axis on accelerometer for calculation. Make sure
% that the Engduino device is placed with the LEDs facing downwards.

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
    e = engduino('COM4');
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

% coefficient to apply filtering
alpha = 0.5;
beta = 0.9;
gamma = 0.9;

% initialise the time
time = repmat(now, 2, 4);
t0 = now;
previous_time =0;

% initialise variables used in calculation
previous_velocity =0;
displacement = 0;
total_displacement = 0;
current_velocity = 0;
init =0;

% Wait to start calculation
while(not(e.getButton()))
    pause(0.1);
end

pause(0.3);
% initialise accelerometer reading
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
    time = repmat((now - t0)*10e4,1,1);
    
    % dt = change in time
    if (init==0)
        dt=0;
        init=1;
    else
        dt = (time - previous_time);
    end
    % Integration from acceleration to velocity to displacement
    current_velocity = previous_velocity + acceleration_Filtered*dt;
    
    % apply low pass filter to velocity result
    velocity_Filtered = (1-gamma)*velocity_Filtered + gamma*current_velocity;

    displacement = previous_velocity*dt + 0.5*acceleration_Filtered*dt*dt;
    total_displacement = total_displacement + displacement;
    previous_velocity = velocity_Filtered;
    
    previous_time = time;
    title(['Distance Travelled: ' num2str(total_displacement, 3) 'm']);
    drawnow;
    % Pause for one time interval.
    pause(1/frequency);
end