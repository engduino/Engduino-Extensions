%% Thermistor Serial
%
% Outputs the temperature in milli degrees celsius. This blocks also prints
% out the value via serial communication.
%
%% Description
% 
% <<../img/Modelling/thermistor_serial.PNG>>
%
% Measure the temperature from the Engduino's thermistor. Output the temperature 
% as milli degrees celsius. The output data is also sent via serial
% communication as a String (eg. 'Temperature value: 27981'). 
% 
%% Example
%
% This model lights up LED 0 when the temperature in milli degrees celsius
% is equal or greater than 28000. 
%
% Refer to <../getTemperatureSerial.html here>
% for the MATLAB code on how to retrieve the sensor data via serial
% communication.
%
% <<../img/Modelling/ThermistorSerialExample.PNG>>  
%
%% Data type
% * Output data type is uint8_t in Simulink
% * For serial communication, the output data is String. For example if the
% temperature data is 27981, then this data is transmitted as "Temperature
% value: 27981".
