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

e.setLed(1);
% Turn on or off Led on the device.
%
% INPUTS
% val = 0 -> Turn Led off
% val = 1 -> Turn Led on
%

e.setLed(0);

e.setLeds([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, 1]);
% Set colors of all 16 RBG Leds on the device
%
% INPUTS
% vals[1-16] = [color1, .... , color16]
% Colors are defined as:
% RED =     0
% GREEN =   1
% BLUE =    2
% YELLOW =  3
% MAGENTA = 4
% CYA =     5
% WHITE =   6
%
% Examples:
% setLeds([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, 1]);
% Sets colors on all 16 RGB Leds.

e.setLedsAll(7);
% Sets a color on all 16 RGB Leds.
% Same color definition as setLeds() function.

e.setLedsOne(10, 1);
% Set the color of one Led.
% Other Leds remains previous states.
% In this example, it sets the 10th Led with the color GREEN.
%
% Examples:
% setLedsOne(10, e.COLOR_BLUE); % Sets color only on tenth Led.

e.setLedsExact(11, 0);
% Set the exact led with the specific color, and other leds will be turned
% OFF
% In this example, the 11th LED will be set as color RED, and all other
% leds will be turned OFF.