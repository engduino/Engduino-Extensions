if (~exist('e', 'var'))
        e = engduino();
end

% e.pinMode(12, e.PIN_TYPE_OUTPUT);
% pins = e.digitalWrite(12,e.PIN_VALUE_LOW);
while (true)
    readings = e.analogRead([1;2;3;]);
    pin1_val = readings(1,2);
    pin2_val = readings(2,2);
    pin3_val = readings(3,2);
    disp(readings);
    pause(0.1);
 end
