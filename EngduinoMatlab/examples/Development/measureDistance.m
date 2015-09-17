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

% keep program running at 10Hz
frequency = 10;
period = 1/10;

xAccel_filtered = 0;
alpha = 0.5;

init =0;
% initialise the time
time = repmat(now, 2, 4);
t0 = now;

previous_velocity = 0;
total_displacement = 0;
acc_threshold = 0.2;
accelerationX = 0;
pause(1);

while(not(e.getButton()))
    pause(0.1);
end

% % initialise accelerometer reading
% for i=1:10
% newReading = e.getAccelerometer();
% xAccel = newReading(1);
% % Low pass filter to remove noise from sensor
% xAccel_filtered = (1-alpha)*xAccel_filtered + alpha*xAccel;
% disp(xAccel);
% end
% 
% disp(xAccel_filtered);
pause(1);
while (not(e.getButton()))
    tStart = tic; 
    newReading = e.getAccelerometer();
    
    xAccel = newReading(1);
    %xAccel_filtered = xAccel;
    % low pass filter accelerometer output
    xAccel_filtered = (1-alpha)*xAccel_filtered + alpha*xAccel;
    
    
    
    disp('x y z');
    disp(newReading);
    
    
    
    
    accelerationX = xAccel_filtered - ((1-alpha)*accelerationX+alpha*xAccel_filtered);
    
    
    accelerationX_filt = (floor(accelerationX*100)/100*10);
    time = repmat((now - t0)*10e4,1,1);
    
     % ignore small value acceleration due to noise
    if(accelerationX_filt>-acc_threshold&&accelerationX_filt<acc_threshold)
        accelerationX_filt = 0;
    end
    disp(accelerationX_filt);

    % change in time
    if (init==0)
        dt=0;
        init =1;
    else
        dt = (time - previous_time);
    end
    
    
    % Integration from acceleration to velocity to displacement
    current_velocity = previous_velocity + accelerationX_filt*dt;
    displacement = previous_velocity*dt + 0.5*accelerationX_filt*dt*dt;
    total_displacement = total_displacement + displacement;
    previous_velocity = current_velocity; 
    previous_time = time;
    
    disp('total_displacement');
    disp(total_displacement);
    
    tElapsed = toc(tStart);
    delayPeriod = period - tElapsed;
    pause(delayPeriod);
end