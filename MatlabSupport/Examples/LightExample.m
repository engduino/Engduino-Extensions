clear all;
e = engduino('COM1', 9600);

% e = engduino(port, param1)
% Creates an Engduino object with selected communication type.
% Available communications are [Com, Bluetooth].
%
% Examples:
% e = engduino('COM47');    Opens ComPort communication
% on port COM47 with the default 9600 baudrate.
%
% e = engduino('COM47', 115200);    Opens ComPort communication
% on port COM47 with the 115200 baudrate.
% 
% e = engduino('Bluetooth', 'HC-05');    Opens Bluetooth communication
% with the device 'HC-05'.

figure; hold on; grid on;
title('Engduino Light Sensor');
xlabel('Time');
ylabel('Light []');
light = [];

for i=1:100
    light(i) = e.getLight();
    plot(light);
    pause(1);
end