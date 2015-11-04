%% analogWrite
% Writes an analog value (PWM wave) to a pin. Can be used to
% light a LED at varying brightnesses or drive a motor at
% various speeds. After a call to analogWrite(), the pin will
% generate a steady square wave of the specified duty cycle
% until the next call to analogWrite() (or a call to
% digitalRead() or digitalWrite() on the same pin). The
% frequency of the PWM signal is approximately 490 Hz. This
% function works on pins 3, 5, 6, 9, 10, 11 and 13. You do not
% need to call pinMode() to set the pin as an output before
% calling analogWrite(). The analogWrite function has nothing
% to do with the analog pins or the analogRead function.
%
%% Syntax
e.analogWrite(pin,value);
e.analogWrite(pin,value,width);
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="#api"><a href="#one">e.analogWrite(pin,value);</a></td>
%      <td>set the output pin and duty-cycle</td> 
%   </tr>
%   <tr>
%      <td id="#api"><a href="#two">e.analogWrite(pin,value,width);</a></td>
%      <td>set the output pin, duty-cycle, and duration</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Set D13 duty-cycle on 123 unconditionally</b></li></a>
% </html>
%
% Connect to Engduino and set pin 13 with duty-cycle of 123

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end
while (true)
    % set pin 13 with 123 duty-cycle
    e.analogWrite(13, 123);
end

%%
%
% <html>
% <a name="two" id="title"><li><b>Set D6# duty-cycle on 75 for a 0.5 second</b></li></a>
% </html>
%
% Connect to Engduino, set D6# duty-cycle on 75 for a 0.5 second. After that the
% duty-cycle will be autoatiacly reset to zero, which will turn
% off that pin:

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
        e = engduino();
end

while (true)
    e.analogWrite(6, 75, 0.5);
end
             
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
%      <td>The duty cycle: between 0 (always off) and 255 (always on)</td> 
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




