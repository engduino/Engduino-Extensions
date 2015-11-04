%% engduino
% Setup connection to Engduino hardware via USB or Bluetooth and create an
% Engduino Object
%
%% Syntax
e = engduino()
e = engduino(port)
e = engduino(port,baudrate)
e = engduino('Bluetooth',device_name)
%% Description
% <html>
% <head>
% <link rel="stylesheet" href="../css/style.css">
% </head>
% <table style="width: 100%" >
%   <tr>
%      <td id="api"><a href="#one">e = engduino()</a></td>
%      <td>Automatically search through the available COM ports and try to connect on one</td> 
%   </tr>
%   <tr>
%      <td id="api"><a href="#two">e = engduino(port)</a></td>
%      <td>Creates a connection to Engduino hardware on the specified port with the default 9600 baudrate</td> 
%   </tr>
%   <tr>
%      <td id="api"><a href="#three">e = engduino(port,baudrate)</a></td>
%      <td>Creates a connection to Engduino hardware on the specified port with the specified baudrate</td> 
%   </tr>
%   <tr>
%      <td id="api"><a href="#four">e = engduino('Bluetooth',device_name)</a></td>
%      <td>Creates a bluetooth communication to Engduino hardware on the specified device. (Additional bluetooth module is required)</td> 
%   </tr>
% </table>
% </html>
% 
%% Examples
%
% <html>
% <a name="one" id="title"><li><b>Connect to Engduino hardware automatically</b></li></a>
% </html>
%
% Automatically find available COM port and connect to one. 

e = engduino();
%%
%
% <html>
% <a name="two" id="title"><li><b>Connect to Engduino hardware on a specified port</b></li></a>
% </html>
%
% Connect to Engduino hardware on port 3

e = engduino('COM3');

%%
%
% <html>
% <a  id="title" name="three"><li><b>Connect to Engduino hardware on a specified port with specified baudrate</b></li></a>
% </html>
%
% Connect to Engduino hardware on port 3 with 115200 baudrate 

e = engduino('COM3',115200);

%%
%
% <html>
% <a name="four" id="title"><li><b>Connect to Engduino hardware via Bluetooth</b></li></a>
% </html>
%
% Connect to Engduino hardware via Bluetooth with the device 'HC-05'

e = engduino('Bluetooth','HC-05');

%% Input Arguments
%
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">port</td>
%      <td>(String) Hardware port</td> 
%   </tr>
%   <tr>
%      <td id="api">baudrate</td>
%      <td>(Integer) Serial communication speed</td> 
%   </tr>
%   <tr>
%      <td id="api">device_name</td>
%      <td>(String) Name of the bluetooth module</td> 
%   </tr>
% </table>
% </html>
% 
%% Output Arguments
% 
% <html>
% <table style="width: 100%" >
%   <tr>
%      <td id="api">e</td>
%      <td>(Object) Communition with Engduino returned as an object</td> 
%   </tr>
% </table>
% </html>
