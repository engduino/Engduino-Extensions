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
acc_threshold = 0.5
vel_threshold = 0.3;
previous_time =0;
previous_velocity =0;
displacement = 0;
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

% initialise the time
time = repmat(now, 2, 4);
t0 = now;

pause(1);
% Wait to start calculation
while(not(e.getButton()))
    pause(0.1);
end

pause(0.5);
% initialise accelerometer reading
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

%% Main Program loop
while (not(e.getButton()))
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    % high pass filter accelerometer output
    gxFilt = gx - ((1-alpha)*gxFilt + alpha*gx);
    
    % subplot raw X acceleration vector
    subplot(1,2,1)
    % clear the current axis
    cla;
    line([0 gx], [0 0], 'color','r','LineWidth',2,'Marker','o');
    % limit plot to +/- 1.25g in all directions and make axis square
    limits = 2.5;
    axis([-limits limits -limits limits]);
    axis square;
    grid on
    xlabel('X-axis acceleration (raw)')
    
    % subplot filtered X acceleration vector
    subplot(1,2,2)
    cla;
    line([0 gxFilt], [0,0],'Color', 'r', 'LineWidth' , 2, 'Marker', 'o');
    % limit plot to +/- 1.25g in all directions and make axis square
    limits = 2.5;
    axis([-limits limits -limits limits]);
    axis square;
    grid on
    xlabel('X-axis acceleration (filtered)')
    
    acceleration = (floor(gxFilt*100)*multiplier/100 - init_accx);
    
    accFilt = (1-beta)*accFilt + beta*acceleration;
    
    % ignore small value acceleration due to noise
    if(accFilt>-acc_threshold&&accFilt<acc_threshold)
        accFilt = 0;
    end
    
    time = repmat((now - t0)*10e4,1,1);
    
    % change in time
    dt = (time - previous_time);
    
    % Integration from acceleration to velocity to displacement
    current_velocity = previous_velocity + accFilt*dt;

    velFilt = (1-gamma)*velFilt + gamma*current_velocity;

    displacement = previous_velocity*dt + 0.5*accFilt*dt*dt;
    total_displacement = total_displacement + displacement;
    previous_velocity = velFilt;
    
    previous_time = time;
    title(['Distance Travelled: ' num2str(total_displacement, 3) 'm']);
    drawnow;

    % Pause for one time interval.
    pause(1/frequency);
    
end