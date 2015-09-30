%% setLedsAll
% Set one colour for all the 16 LEDs on Engduino
%
%% Syntax
e.setLedsAll(colour);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.setLedsAll(colour)</a></td>
%      <td>Function takes one LED colour as input, set one colour for all the 16 LEDs on Engduino</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Set the colour of the LEDs</b></li></a>
% </html>
%
% Connect to Engduino on port 3 and set the Colour of all the LEDs to red

% Colours are defined in engduino object as:
%     COLOR_RED =     0
%     COLOR_GREEN =   1
%     COLOR_BLUE =    2
%     COLOR_YELLOW =  3
%     COLOR_MAGENTA = 4
%     COLOR_CYA =     5
%     COLOR_WHITE =   6
%     COLOR_OFF =     7

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end
e.setLedsAll(e.COLOR_GREEN);

%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">colour</td>
%      <td>Can be an integer value of 0-7 or use the colour properties in Engduino object</td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">res</td>
%      <td>Return status to indicate whether function has been executed (int) 0: OK, <0: Error code</td> 
%   </tr>
% </table>
% </html>
%% Properties
% * <../engduino_leds.html#colour_properties LED Colours>
%
