%% getMagnetometer
% Get the xyz value of magnetometer on Engduino
%
%% Syntax
magReading = e.getMagnetometer();
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getMagnetometer()</a></td>
%      <td>Return 1x3 matrix which contains xyz value of Engduino's Magnetometer</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Get the xyz value of Magnetometer</b></li></a>
% </html>
%
% Connect to Engduino, Read Magnetometer

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get magnetometer reading
    magReading = e.getMagnetometer();
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
%      <td id="api">magReading</td>
%      <td>Return a 1x3 Matrix that contains the xyz value of Engduino's magnetometer</td> 
%   </tr>
% </table>
% </html>

