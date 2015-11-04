%% getButton
% Get the status of the button on Engduino whether it is pressed or
% released.
%
%% Syntax
status = e.getButton();
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.getButton()</a></td>
%      <td>Get the state of the button on Engduino, function return true or false</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Turn on LED when button is pressed</b></li></a>
% </html>
%
% Connect to Engduino, turn on LED when button pressed

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % read the status of the button
    status = e.getButton()
    if status
        % turn on LED
        e.setLed(1);
    else 
        % turn off LED
         e.setLed(0);
    end
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
%      <td id="api">status</td>
%      <td>Return button state. 1 - is pressed, 0 - otherwise</td> 
%   </tr>
% </table>
% </html>

