%% getLight
% Measure light intensity from light sensor on Engduino
%
%% Syntax
light_intensity = e.getLight();
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getLight()</a></td>
%      <td>Return an integer value of the light intensity measured</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Get the light intensity from Engduino</b></li></a>
% </html>
%
% Connect to Engduino, Get reading from light sensor

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get accelerometer reading
    light_intensity = e.getLight();
end
%% Input Arguments
%
% No input arguments.
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td style="width:30%">light_intensity</td>
%      <td>Return (int)value of the light intensity measured</td> 
%   </tr>
% </table>
% </html>

