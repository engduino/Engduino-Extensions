% SimpleLowPassHighPassFilter.m demo example.
%
% Description:
% This example shows the implementation of a low pass and high pass filter to 
% filter the accelerometer sensors value.
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
    e = engduino('COM4');
end

% Set reading frequency [Hz] - readings per second.
frequency = 10;
 
% filter
gxFilt_low = 0;
gxFilt_high = 0;
% filter control coefficient
alpha = 0.5;

while (not(e.getButton()))
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    
    gx = newReading(1);
    
    % low pass filter accelerometer output
    gxFilt_low = (1-alpha)*gxFilt_low + alpha*gx;
    
    % high pass filter accelerometer output
    gxFilt_high = gx - ((1-alpha)*gxFilt_high + alpha*gx);
    
    % subplot raw X acceleration vector
    subplot(2,2,1)
    % clear the current axis
    cla;
    line([0 gx], [0 0], 'color','r','LineWidth',2,'Marker','o');
    % limit plot to +/- 2.5g in all direction
    limits = 2.5;
    axis([-limits limits -limits limits]);
    % make axis square
    axis square;
    grid on
    xlabel('X-axis acceleration (raw)')
    
    % subplot filtered X acceleration vector
    subplot(2,2,2)
    cla;
    line([0 gxFilt_low], [0,0],'Color', 'r', 'LineWidth' , 2, 'Marker', 'o');
    % limit plot to +/- 2.5g in all direction
    limits = 2.5;
    axis([-limits limits -limits limits]);
    % make axis square
    axis square;
    grid on
    xlabel('X-axis acceleration (Low-pass filtered)')
    
    % subplot filtered X acceleration vector
    subplot(2,2,3)
    cla;
    line([0 gxFilt_high], [0,0],'Color', 'r', 'LineWidth' , 2, 'Marker', 'o');
    % limit plot to +/- 2.5g in all direction
    limits = 2.5;
    axis([-limits limits -limits limits]);
    % make axis square
    axis square;
    grid on
    xlabel('X-axis acceleration (High-pass filtered)')
    
    drawnow;
    
    % Pause for one time interval.
    pause(1/frequency);
    
end