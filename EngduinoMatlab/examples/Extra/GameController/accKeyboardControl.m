  %                             % accKeyboardControl.m demo example.
%   
% T    his example shows how to use Accelerometer on the Engduino as a game controller. 
% The accelerometer data is calculated and mapped to simulate keypress on
% the keyboard with the use of external Java library for the key mapping.
%
% July 2015, Engduino team: support@engduino.org

%% Import External Library
% Import Java robot for keyboard control. 
% This Java class is not officially supported by Matlab. Please refer
% to Java website for more information on this class
import java.awt.Robot;

%% Initialize variables
% Declare the java object
robot = Robot;
% Set reading frequency [Hz] - readings per second.
frequency = 150 ;
% Set the left right steering sensitivity
LRsensitivity = 30;
% Set the up down steering sensitivity
UpDownSensitivity = 10;

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
    e = engduino('Bluetooth', 'HC-05');
end

%% Wait to start calculation
while(not(e.getButton()))
    pause(0.1);
end

pause(0.3);

% initialise starting accelerometer position
newReading = e.getAccelerometer();
gx = newReading(1);
gy = newReading(2);
gz = newReading(3);
% set the initial tilt position of the acceleromter
thetaUD_init = atand(gx/gz);
%% Main loop
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
    
    % offset the up/down tilt axis
    upDownAxis = thetaUD - thetaUD_init;

    if(thetaLR<-LRsensitivity&&thetaUD<0)
        %disp('Move left');
        robot.keyPress(java.awt.event.KeyEvent.VK_LEFT); 
    elseif(thetaLR>LRsensitivity&&thetaUD<0)  
        %disp('Move  right');
        robot.keyPress(java.awt.event.KeyEvent.VK_RIGHT);
    elseif(thetaLR<-LRsensitivity&&thetaUD>=0)
        % inverse the control when up/down tilt angle >=0
        %disp('Move right');
        robot.keyPress(java.awt.event.KeyEvent.VK_RIGHT);
    elseif(thetaLR>LRsensitivity&&thetaUD>=0)
        %disp('Move left');
        robot.keyPress(java.awt.event.KeyEvent.VK_LEFT);
    else
        
        robot.keyRelease(java.awt.event.KeyEvent.VK_LEFT); 
        robot.keyRelease(java.awt.event.KeyEvent.VK_RIGHT); 
    end
    
    if(upDownAxis<-UpDownSensitivity)
        %disp('Move down');
        robot.keyPress(java.awt.event.KeyEvent.VK_DOWN); 
    elseif (upDownAxis>UpDownSensitivity)
        %disp('Move up');
        robot.keyPress(java.awt.event.KeyEvent.VK_UP); 
    else
        robot.keyRelease(java.awt.event.KeyEvent.VK_UP); 
        robot.keyRelease(java.awt.event.KeyEvent.VK_DOWN); 
    end
    
    % Map the button on Engduino to a Key
    if (e.getButton())
        %disp('Shooting');
        robot.keyPress(java.awt.event.KeyEvent.VK_SPACE);
    elseif (not(e.getButton()))
        %disp('not Shooting');
        robot.keyRelease(java.awt.event.KeyEvent.VK_SPACE );
    end
    
    % display the tilt angle calculated
    title(['LeftRight tilt angle: ' num2str(thetaLR, '%.0f'), ...
        ' UpDown tilt angle: ' num2str(thetaUD, '%.0f')]);
    
    % Pause for one time interval.
    pause(1/frequency);
    
end