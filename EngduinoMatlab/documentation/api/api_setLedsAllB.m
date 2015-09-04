%% setLedsAllB
% Set the colour and brightness of all 16 LEDs on Engduino
%
%% Syntax
e.setLedsAllB(colour,brightness);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.setLedsAllB(colour,brightness)</a></td>
%      <td>First parameter sets the colour and the second parameter sets brightness level of all the 16 LEDs</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Set the colour and brightness of the 16 LEDs</b></li></a>
% </html>
%
% Connect to Engduino on port 3 and set the colours and brightness of the
% 16 LEDs

% Colours are defined in engduino object as:
%     COLOR_RED =     0
%     COLOR_GREEN =   1
%     COLOR_BLUE =    2
%     COLOR_YELLOW =  3
%     COLOR_MAGENTA = 4
%     COLOR_CYA =     5
%     COLOR_WHITE =   6
%     COLOR_OFF =     7
% Brightness level from 0-15

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end
e.setLedsAllB(e.COLOR_RED,1);

%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">colour</td>
%      <td>Can be an integer value of 0-7 or use the colour properties in Engduino object</td> 
%   </tr>
%   <tr>
%      <td id="api">brightness</td>
%      <td>The brightness level of LED in the range [0-15] </td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td style="width:30%">res</td>
%      <td>Return status to indicate whether function has been executed (int) 0: OK, <0: Error code</td> 
%   </tr>
% </table>
% </html>
%% Properties
% * <../engduino_leds.html#colour_properties LED Colours>
%
