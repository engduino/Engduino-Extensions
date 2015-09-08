%% accKeyboardControl.m demo example.
%
% This example shows how to use Accelerometer on the Engduino as a game controller. 
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
    e = engduino('COM10');
end

robot = Robot;

% Set reading frequency [Hz] - readings per second.
frequency = 100 ;
 

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
    
    upDownAxis = thetaUD - thetaUD_init;
    
    title(['LeftRight tilt angle: ' num2str(thetaLR, '%.0f'), ' UpDown tilt angle: ' num2str(thetaUD, '%.0f')]);

    if(thetaLR<-30)
        disp('Move left');
        robot.keyPress(java.awt.event.KeyEvent.VK_LEFT); 
    elseif(thetaLR>30)  
        disp('Move  right');
        robot.keyPress(java.awt.event.KeyEvent.VK_RIGHT);
    else
        robot.keyRelease(java.awt.event.KeyEvent.VK_LEFT); 
        robot.keyRelease(java.awt.event.KeyEvent.VK_RIGHT); 
    end
    
    if(upDownAxis<-30)
        disp('Move down');
        robot.keyPress(java.awt.event.KeyEvent.VK_DOWN); 
    elseif (upDownAxis>30)
        disp('Move up');
        robot.keyPress(java.awt.event.KeyEvent.VK_UP); 
    else
        robot.keyRelease(java.awt.event.KeyEvent.VK_UP); 
        robot.keyRelease(java.awt.event.KeyEvent.VK_DOWN); 
    end
    
    % Map the button on Engduino to a Key
    if (e.getButton())
        disp('Shooting');
        robot.keyPress(java.awt.event.KeyEvent.VK_SPACE);
    elseif (not(e.getButton()))
        disp('not Shooting');
        robot.keyRelease(java.awt.event.KeyEvent.VK_SPACE );
    end
    % Pause for one time interval.
    pause(1/frequency);
    
end