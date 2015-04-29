%% Test script
clear all
e=engduino('COM8', 9600);
e.setLedsAll(1)

for i=1:116
    e.leds = ones(1,16).*7;
    e.setLedsOne(mod(i,15)+1, e.COLOR_RED);
end

%%
leds = [0, 1, 2];
for i=1:50
    e.setLedsExact(mod(leds, 16), [e.COLOR_RED, e.COLOR_GREEN, e.COLOR_BLUE]);
    leds = leds + [1,1,1];
    pause(0.01);
end

%%
figure; hold on; grid on;
title('Engduino Temperature');
xlabel('Time');
ylabel('Temperature [degrees]')
temp = [];

for i=1:100
    tic
    temp(i) = e.getTemperature();
    %temp(i) = e.getLight();
    toc
    plot(temp);
    pause(0.1)
end

%%
figure; hold on; grid on;
title('Engduino Accelerometer');
xlabel('Time');
ylabel('Acceleration [G]')

acc = [];
acc(1, :) = [0, 0, 0];
time = [0];
tnow = now;


plot(time, acc, '-', 'Linewidth', 2);
legend({'Acc X', 'Acc Y', 'Acc Z'})


for i=1:100
    %tic
    acc(i,:) = e.getAccelerometer();
    time(i) = (now - tnow)*10e4;
    %toc
    plot(time, acc, '-', 'Linewidth', 2);
    ssum = sqrt(sum(acc(i,:).^2, 2));
    disp(['Sum: ' num2str(ssum)]);
    
    pause(0.001);
end

 %% Light Leds
light = e.getLight();
for i=1:100
    light = 0.7*light + 0.3*e.getLight(); % Lowpass filter
    leds = ones(1, 16).*e.COLOR_OFF;
    lval = floor(light/60);
    leds(1:lval) = ones(1, length(lval)).*e.COLOR_WHITE;
    e.setLeds(leds);
end

%% On-off
for i=1:10000
    e.setLedsAll(e.COLOR_WHITE);
    pause(0.1)
    e.setLedsAll(e.COLOR_OFF);
end

%% Brightness
e.setLedsB(zeros(1,16), (0:15));

%% IO
e.setDigitalPinsType([13, e.PIN_TYPE_OUTPUT]);
e.setDigitalPinsValue([13, 1, 200]);
%e.setDigitalPinsValue([12, 1, 200; 13, 1, 1000]);

%% Crash with timers!
e.setDigitalPinsType([13, e.PIN_TYPE_OUTPUT]);
e.setAnalogPinsValue([13, 155, 1000]);

%%
e.getDigitalPinsValue([13; 12; 7])
e.getAnalogPinsValue([0; 1; 2; 3; 4; 5])

