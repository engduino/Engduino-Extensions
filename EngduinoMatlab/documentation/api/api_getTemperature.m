%% getTemperature
% Get the temperature value in celcius from Engduino
%
%% Syntax
tempCelcius = e.getTemperature();
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getTemperature()</a></td>
%      <td>Return temperature reading in celcius</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Get temperature value</b></li></a>
% </html>
%
% Connect to Engduino, Read temperature sensor

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get temperature reading
    tempCelcius = e.getTemperature();
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
%      <td id="api">tempCelcius</td>
%      <td>Return (float)value of temperature in celcius</td> 
%   </tr>
% </table>
% </html>

