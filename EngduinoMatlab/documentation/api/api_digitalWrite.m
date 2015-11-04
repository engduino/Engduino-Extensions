%% digitalWrite
% Write a HIGH or a LOW value to a digital pin.
% If the pin has been configured as an OUTPUT with pinMode(), 
% its voltage will be set to the corresponding value: 5V 
% (or 3.3V on 3.3V boards) for HIGH, 0V (ground) for LOW. The
% width input parameter is optional. Pulse width set on less 
% than 1 will set pin unconditionally, where the values larger
% than 1 will set a pin for a required time interval in 
% seconds and negate its state after that. 
%
% If the pin is configured as an INPUT, digitalWrite() will 
% enable (HIGH) or disable (LOW) the internal pullup on the 
% input pin. It is recommended to set the pinMode() to 
% INPUT_PULLUP to enable the internal pull-up resistor.
% 
% NOTE: If you do not set the pinMode() to OUTPUT, and connect
% an LED to a pin, when calling digitalWrite(HIGH), the LED
% may appear dim. Without explicitly setting pinMode(), 
% digitalWrite() will have enabled the internal pull-up 
% resistor, which acts like a large current-limiting resistor.
%
%% Syntax
e.digitalWrite(pin,value);
e.digitalWrite(pin,value,width);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e.digitalWrite(pin,value);</a></td>
%      <td>set the output pin to value HIGH or LOW</td> 
%   </tr>
%   <tr>
%      <td id="api"><a href="#two">e.digitalWrite(pin,value,width);</a></td>
%      <td>set the output pin to value HIGH or LOW for specific duration then negate its state</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>set digital pin 13 to output HIGH</b></li></a>
% </html>
%
% Connect to Engduino, configure digital pin 13 as output pin, and output HIGH 

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

e.pinMode(13, e.PIN_TYPE_OUTPUT);
e.digitalWrite(13,e.PIN_VALUE_HIGH);


%%
%
% <html>
% <a name="two" id="title"><li><b>Set digital pin 13 to output LOW for specific duration then negate it</b></li></a>
% </html>
%
% Connect to Engduino, configure digital pin 13 as output pin, and output
% LOW for 1.5s

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

e.pinMode(13, e.PIN_TYPE_OUTPUT);
e.digitalWrite(13,e.PIN_VALUE_HIGH,1.5);
             
%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">pin</td>
%      <td>Pin number</td> 
%   </tr>
%   <tr>
%      <td id="api">value</td>
%      <td>e.PIN_VALUE_HIGH or e.PIN_VALUE_LOW state</td> 
%   </tr>
%   <tr>
%      <td id="api">width</td>
%      <td>Pulse width in seconds (optional)</td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">res</td>
%      <td>Return status to indicate whether function has been executed (int) 0: OK, <0: Error code</td> 
%   </tr>
% </table>
% </html>




