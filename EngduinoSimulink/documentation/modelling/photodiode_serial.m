%% Photodiode Serial
%
% Outputs the light intensity data in the range between 0-1023. This blocks also prints
% out the value via serial communication.
%
%% Description
% 
% <<../img/Modelling/photodiode_serial.PNG>>
%
% Measure the light intensity from the Engduino's photodiode. Output the light intensity 
% as a 10 bit value between 0-1023. The output data is also sent via serial
% communication as a String (eg. 'Light value: 300'). 
% 
%% Example
%
% This model change LED 0 to blue when the light intensity level is greater 
% than 300, otherwise red. 
%
% Refer to <../getTemperatureSerial.html here>
% for the MATLAB code on how to retrieve the sensor data via serial
% communication.
%
% <<../img/Modelling/PhotodiodeSerialExample.PNG>>  
%
%% Data type
% * Output data type is uint8_t in Simulink
% * For serial communication, the output data is String. For example if the
% light intensity data is 300, then this data is transmitted as "Light
% value: 300".
