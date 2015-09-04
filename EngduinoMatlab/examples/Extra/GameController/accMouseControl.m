% accKeyboardControl.m demo example.
%
% Description:
% This example shows how to use Accelerometer on the Engduino as a game controller. 
% The accelerometer data is calculated and mapped to simulate keypress on
% the keyboard.
%
% July 2015, Engduino team: support@engduino.org

% Import Java robot for keyboard control. 
% Note: this Java class is not officially supported by Matlab. Please refer
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
frequency = 100 ;
 

% initialise starting accelerometer position
newReading = e.getAccelerometer();
gx = newReading(1);
gy = newReading(2);
gz = newReading(3);
% set the initial tilt position of the acceleromter
thetaUD_init = atand(gx/gz);

while (1)
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    % calculate the angle of the resultant acceleration Left Right
    thetaLR = atand(gy/gx);
    
    % calculate the angle of the resultant acceleration Up Down
    thetaUD = atand(gx/gz);
    
    upDownAxis = thetaUD - thetaUD_init;
    
    title(['LeftRight tilt angle: ' num2str(thetaLR, '%.0f'), ' UpDown tilt angle: ' num2str(thetaUD, '%.0f')]);

    % get current mouse position
    mouse_current_loc = get(0, 'PointerLocation');

    mouseXpos = mouse_current_loc(1);
    mouseYpos = mouse_current_loc(2);
    
    if(thetaLR<-30)
        disp(['Before Left' num2str(mouse_current_loc)]);
        robot.mouseMove(mouseXpos-5,mouseYpos);
        disp(['After Left' num2str(mouse_current_loc)]);
    elseif(thetaLR>30)  
        disp(['Before Right' num2str(mouse_current_loc)]);
        robot.mouseMove(mouseXpos+5,mouseYpos);
        disp(['After Right' num2str(mouse_current_loc)]);
    else
        
    end
    
    if(upDownAxis<-30)
        disp(['Before Down' num2str(mouse_current_loc)]);
        robot.mouseMove(mouseXpos,mouseYpos-5);
        disp(['After Down' num2str(mouse_current_loc)]);
    elseif (upDownAxis>30)
        disp(['Before Up' num2str(mouse_current_loc)]);
        robot.mouseMove(mouseXpos,mouseYpos+5);
        disp(['After Up' num2str(mouse_current_loc)]);
    else

    end
    
    if (e.getButton())
        robot.keyPress(java.awt.event.KeyEvent.VK_SPACE);
    elseif (not(e.getButton()))
        robot.keyRelease(java.awt.event.KeyEvent.VK_SPACE );
    end
    % Pause for one time interval.
    pause(1/frequency);
end