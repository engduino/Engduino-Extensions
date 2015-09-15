frequency = 10;
if (~exist('e','var'))
    e = engduino('COM4');
end

height = 1.38;


while(1)
    
    newReading = e.getAccelerometer();
    gx = newReading(1);
    gy = newReading(2);
    gz = newReading(3);
    
    ud_angle = atand(gz/gy);
    
    inner_angle = 90-ud_angle;
    
    if(inner_angle>90||inner_angle<0)
        disp('MAX');
    else
        angleInRadians = degtorad(inner_angle);
        distance = height*tan(angleInRadians);
    
        round_up_distance = floor(distance*10)/10;
        disp('angle');
        disp(floor(inner_angle));
        disp('distance');
        disp(round_up_distance);
    end
    pause (1/frequency);
end