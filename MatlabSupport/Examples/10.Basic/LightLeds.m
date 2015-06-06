%% LightLeds.m demo example.
%
% Description: 
% The aim of this example is to detect light intensity and turn on LEDs
% based on the intensity level. To avoid rapid changes in measured light
% intensity we added a simple Low-pass filter. The result after filtering
% is more smooth signal without spikes.
%
% July 2014, Engduino team: support@engduino.org
% 

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
    e = engduino();
end

% Set frequency [Hz]. Steps per second.
frequency = 25;

% Mid value of light's full scale (2^10).
light_val = 2^9;
 
%% Main loop
% Execute loop until exit condition is met.
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition([], e, true)

    % Lowpass filter
    % Higher value of alpha (a) will follow into less filtered signal.
    a = 0.2;
    light_val = (1-a)*light_val + a*e.getLight(); 
    
    % Turn on Leds 
    % The result is a 10-bit value - so in a range [0-1023]. If we spread
    % this between our 16 LEDs evenly, it means we have to divide the value
    % obtained by 64 to tell us what the biggest numbered LED we have to
    % turn on.
    leds = ones(1, 16).*e.COLOR_OFF;
    lval = floor(light_val/64);
    leds(1:lval) = ones(1, length(lval)).*e.COLOR_WHITE;
    e.setLeds(leds);
    
    % Pause for one time interval.
    pause(1/frequency);
end