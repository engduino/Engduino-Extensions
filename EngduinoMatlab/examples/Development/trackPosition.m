% GetAccelerometer.m demo example.
%
% Description:
% This example shows Engduino Sensors 'getTemperature' function call. 
% Function returns acceleration in [x,y,z] directions. Unit is [G=10m/s^2] 
%
% July 2014, Engduino team: support@engduino.org

% Import Java robot for keyboard control. 
% Note this Java class is not officially supported by Matlab. Please refer
% to Java website for more information on this class
import java.awt.Robot;

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

robot = Robot;

e = engduino(port);

%% Initialize variables
% Set reading frequency [Hz] - readings per second.
frequency = 10;
 
total_displacement = 0;
% filter
gxFilt = 0;
gyFilt = 0;
gzFilt = 0;

% filter control coefficient
alpha = 0.5;

time = repmat(now, 2, 4);
t0 = now;
previous_time = 0;

newReading = e.getAccelerometer();
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    acceleration_init= sqrt(gx*gx+gy*gy+gz*gz);

i = 1;
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
    
    % subplot raw X acceleration vector
    subplot(1,2,1)
    % clear the current axis
    cla;
    line([0 gx], [0 0], 'color','r','LineWidth',2,'Marker','o');
    line([0 0], [0 gy], 'color','g','LineWidth',2,'Marker','o');
    % limit plot to +/- 1.25g in all directions and make axis square
    limits = 2.5;
    axis([-limits limits -limits limits]);
    axis square;
    grid on
    xlabel('X-axis acceleration (raw)')
    
    % calculate the angle of the resultant acceleration Left Right
    thetaLR = atand(gy/gx);
    % calculate the angle of the resultant acceleration Up Down
    thetaUD = atand(gx/gz);
    acceleration = sqrt(gxFilt*gxFilt+gyFilt*gyFilt+gzFilt*gzFilt)-acceleration_init;
    
%     annotation('textbox',...
%     [0.15 0.05 0.85 0.12],...
%     'String',{['Accelerometer left right tilt angle: ' num2str(thetaLR, '%.0f')]},...
%     'FontSize',14,...
%     'FontName','Arial',...
%     'LineStyle','--',...
%     'EdgeColor',[1 1 0],...
%     'LineWidth',2,...
%     'BackgroundColor',[0.9  0.9 0.9],...
%     'Color',[0.84 0.16 0]);
    
    % title(['LeftRight tilt angle: ' num2str(thetaLR, '%.0f'), ' UpDown tilt angle: ' num2str(thetaUD, '%.0f')]);
    % title(['Acceleration: ' num2str(acceleration, '%.0f')]);
    time = repmat((now - t0)*10e4,1,1);

    
    dt = time - previous_time;
    previous_time = time;
    
    displacement = acc2disp(acceleration,dt);
    total_displacement = total_displacement + int32(displacement);
    a(i,:) = [acceleration, time];
    

    title(['total displacement: ' num2str(total_displacement, '%.0f')]);
    
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
    
    disp(time);
    drawnow;
    
    i = i+1;
    % Pause for one time interval.
    pause(1/frequency);
    
end
disp(a);


dlmwrite('myFile.txt',a,'delimiter','\t','precision',3)

