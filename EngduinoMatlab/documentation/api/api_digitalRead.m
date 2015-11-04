%% digitalRead
% Reads the value from the specified digital pin. 
% Returns digital pins state as a n x 2 array, representing 
% KEY-VALUE pairs of digital pins. 
%
%% Syntax
readings = e.digitalRead(pins);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td style="width:40%"><a href="#one">e.digitalRead(pin);</a></td>
%      <td>Reads the value from the specified digital pin.</td> 
%   </tr>
%   <tr>
%      <td style="width:40%"><a href="#two">e.digitalRead(pin1;pin2l..pinN);</a></td>
%      <td>Reads the value from multiple digital pin.</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Read value from digital pin 3</b></li></a>
% </html>
%
% Connect to Engduino and start reading digital value from pin 3

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end
while (true)
    % Get reading from analog pin 3
    pin3 = e.digitalRead(3);
end

%%
%
% <html>
% <a name="two" id="title"><li><b>Read value from digital pin 1,2,3</b></li></a>
% </html>
%
% Connect to Engduino and start reading multiple digital pin values

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get reading from digital pin 1,2,3
    readings = e.digitalRead([1;2;3;]);
    pin1_val = readings(1,2)
    pin2_val = readings(2,2)
    pin3_val = readings(3,2)
end
             
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td style="width:30%">pins</td>
%      <td>Input parameter can be scalars or vectors enabling setting
%          multiple pins at once. </td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">readings</td>
%      <td>A n x 2 array of requested pins state. eg. [pin_no,pin_value]</td> 
%   </tr>
% </table>
% </html>




