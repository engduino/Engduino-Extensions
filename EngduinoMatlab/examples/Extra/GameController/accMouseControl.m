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



robot = Robot;

e = engduino(port);

%% Initialize variables
% Set reading frequency [Hz] - readings per second.
frequency = 100 ;
 
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