% Set reading frequency [Hz] - readings per second.
frequency = 10;
% Height
height = 1.5;
measure_distance = true;
if (~exist('e', 'var'))
    e = engduino();
end
while (1)
    % Read acceleration vector from Engduino's accelerometer sensor.
    newReading = e.getAccelerometer();
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    outer_angle = atand(gz/gy);
    
    inner_angle = 90-outer_angle;
    angleInRadians = deg2rad(inner_angle);
    
    if(measure_distance)
        % measuring distance and update the distance
        if(inner_angle>=90||inner_angle<=0)
            disp('Max');
        else
            distance = height*tan(angleInRadians);
            round_up_distance = round(distance*100)/100;
            textLabel = strcat('Distance ',(num2str(round_up_distance)));
            disp(textLabel);
        end
    else
        % measuring height and update the height
        temp_height = distance/(tan(angleInRadians));
        object_height = height-temp_height;
        round_up_height = round(object_height*100)/100;
        textLabel2 = strcat('Height ',(num2str(round_up_height)));
        disp(textLabel2);
    end
    
    if(e.getButton())
      if(measure_distance)
          measure_distance=false;
      else
          measure_distance=true;
      end
    end
    pause(1/frequency);
end

