%% setLedsB
% Set individual colours and brightness for all 16 LEDs on Engduino
%
%% Syntax
e.getStatus(parameters);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.setLedsB([1x16_Colour],[1x16_Brightness])</a></td>
%      <td>first parameter is a 1x16 matrix that set the colour of the LEDs. The second parameter is a
%       1x16 matrix that set the brightness of the LEDs.</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Set the individual colour and brightness of the 16 LEDs</b></li></a>
% </html>
%
% Connect to Engduino on port 3 and set the colours and brightness for each
% LEDs, the column of the matrix correspond to the position LEDs on Engduino

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
e.setLedsB([0,1,2,3,4,5,6,7,0,1,2,3,4,5,6,7],[1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]);

%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">[1x16_Colour]</td>
%      <td>A one 1x16 matrix with values representing the colours in the range of [0-7]. The 
%       order correspond to the position of the LED</td> 
%   </tr>
%   <tr>
%      <td id="api">[1x16_Brightness]</td>
%      <td>A one 1x16 matrix with values representing the LEDs brightness. The 
%       order correspond to the position of the LED </td> 
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
