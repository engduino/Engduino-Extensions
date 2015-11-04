%% Thermistor
%
% Outputs the temperature in milli degrees celsius
%
%% Description
% 
% <<../img/Modelling/Thermistor.PNG>>
%
% Measure the temperature from the Engduino's thermistor. Output the temperature 
% as milli degrees celsius.
% 
%% Example
%
% This model measures the temperature change in the environment. If there is
% a temperature change, LED 1 will become red, otherwise blue.
%
% <<../img/Modelling/ThermistorExample.PNG>>
% 
% The derivative blocks compare the difference between the current input
% and the previous input.
%
%% Data type
% Output data type is uint16_t
