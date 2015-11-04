%% analogRead
% Reads the value from the specified analog pin. Returns analog pins state 
% as a n x 2 array, representing KEY-VALUE pairs of digital pins. The Engduino
% board contains a 5 channel 10-bit analog to digital
% converter. This means that it will map input voltages between
% 0 and 3.3 volts into integer values between 0 and 1023. This
% yields a resolution between readings of: 3.3 volts / 1024
% units or, .0032 volts (3.2 mV) per unit.  It takes about 100
% microseconds
%
%% Syntax
readings = e.analogRead(pins);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.analogRead(pin);</a></td>
%      <td>Reads the value from the specified analog pin.</td> 
%   </tr>
%   <tr>
%      <td id="api"><a href="#two">e.analogRead(pin1;pin2l..pinN);</a></td>
%      <td>Reads the value from multiple analog pin. Function returns a Nx2 matrix with column one specify the pin number and column 2 returns the respective pin's analog value</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Read value from analog pin 3</b></li></a>
% </html>
%
% Connect to Engduino and start reading analog value from pin 3

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end
while (true)
    % Get reading from analog pin 3
    pin3 = e.analogRead(3);
end

%%
%
% <html>
% <a name="two" id="title"><li><b>Read value from analog pin 1,2,3</b></li></a>
% </html>
%
% Connect to Engduino and start reading multiple analog values

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    % Get reading from analog pin 1,2,3
    readings = e.analogRead([1;2;3;]);
    pin1_val = readings(1,2)
    pin2_val = readings(2,2)
    pin3_val = readings(3,2)
end
             
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">pins</td>
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




