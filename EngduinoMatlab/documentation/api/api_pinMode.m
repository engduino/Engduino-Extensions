%% pinMode
% Configures the specified pin to behave either as an input or
% an output. See the description of digital pins for details on
% the functionality of the pins. It is possible to enable the
% internal pullup resistors with the mode INPUT_PULLUP.
% Additionally, the INPUT mode explicitly disables the internal
% pullups.
% 
% NOTE: If you do not set the pinMode() to OUTPUT, and connect
% an LED to a pin, when calling digitalWrite(HIGH), the LED
% may appear dim. Without explicitly setting pinMode(), 
% digitalWrite() will have enabled the internal pull-up 
% resistor, which acts like a large current-limiting resistor.
%
%% Syntax
e.pinMode(pin, configuration);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="#api"><a href="#one">e.pinMode(pin, configuration);</a></td>
%      <td>set the pin as input or output</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>set digital pin 13</b></li></a>
% </html>
%
% Connect to Engduino, configure digital pin 13 as output pin

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

e.pinMode(13, e.PIN_TYPE_OUTPUT);

             
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">pin</td>
%      <td>Pin number</td> 
%   </tr>
%   <tr>
%      <td id="api">configuration</td>
%      <td>e.PIN_TYPE_INPUT or e.PIN_TYPE_OUTPUT state</td> 
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




