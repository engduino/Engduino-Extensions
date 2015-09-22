%% getAccelerometer
% Get the xyz value of accelerometer on Engduino
%
%% Syntax
accReading = e.getAccelerometer();
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getAccelerometer()</a></td>
%      <td>Return 1x3 matrix which contains xyz value of Engduino accelerometer</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Get the xyz value of Accelerometer</b></li></a>
% </html>
%
% Connect to Engduino, Read Accelerometer

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get accelerometer reading
    accReading = e.getAccelerometer();
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
%      <td style="width:30%">accReading</td>
%      <td>Return a 1x3 Matrix that contains the xyz value of Engduino's accelerometer</td> 
%   </tr>
% </table>
% </html>

