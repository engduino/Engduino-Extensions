%% Read Serial
%
% Read the received data sent to Engduino via serial communication.
%
%% Description
% 
% <<../img/Modelling/read_serial.PNG>>
%
% Data is transmitted through serial communication and received in their Ascii
% DEC value. If no data is received, it will output 0. The data received can be used to control Engduino. 
% 
%% Example
%
% This model receive the one byte of data through serial communication. It
% then compare the value. If "1" (ascii value =49) is received, it turns
% led 0 to red
%
% <<../img/Modelling/read_serial_example.PNG>>
%
%% Data type
% Output data type is uint16_t
