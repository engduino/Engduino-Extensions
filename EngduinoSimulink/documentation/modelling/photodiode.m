%% Photodiode
%
% Outputs the light level as a uint16, in the range 0-1023.
%
%% Description
% 
% <<../img/Modelling/photodiode.PNG>>
%
% Uses the Engduino's photodiode to measure light intensity. Output the
% measurement as a 10-bit value that ranges from 0-1023
% 
%% Example
%
% This model measures the light intensity of the environment. If the light 
% intensity level <=300, the led turns red, otherwise blue.
%
% <<../img/Modelling/PhotodiodeExample.PNG>>
%
%% Data type
% Output data type is uint16_t
