% GetAccelerometer.m demo example.
%
% Description:
% This example shows Engduino Sensors 'getTemperature' function call. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
%
% July 2014, Engduino team: support@engduino.org
 
% Clear all variables and objects 
clear all; close all;
addpath(genpath('../../core'))
% Create Engduino object and open COM port. You need to select active COM 
% port on which the Engduino is connected. E.g. COM47. 
% To open 'Bluetooth' port change initialization as suggested in Initial.m 
% E.g. e = engduino('Bluetooth', 'your_device_name');
% Set "port = demo" to enable demo run.
port = 'demo';
port = 'COM3';
e = engduino(port);

%% Initialize variables
% Set reading frequency [Hz] - readings per second.
frequency = 10;
 

% filter
gxFilt = 0;
gyFilt = 0;
gzFilt = 0;
% filter control coefficient
alpha = 0.5;

while (not(e.getButton()))
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    % low pass filter accelerometer output
    gxFilt = (1-alpha)*gxFilt + alpha*gx;
    gyFilt = (1-alpha)*gyFilt + alpha*gy;
    gzFilt = (1-alpha)*gzFilt + alpha*gz;
  
    acceleration = sqrt(gxFilt*gxFilt+gyFilt*gyFilt+gzFilt*gzFilt);
    disp(acceleration*10);
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
    
    % calculate the angle of the resultant acceleration vactor and print
    theta = atand(gy/gx);
    title(['Accelerometer tilt angle: ' num2str(theta, '%.0f')]);
    
    
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
    
    drawnow;
    
    % Pause for one time interval.
    pause(1/frequency);
    
end