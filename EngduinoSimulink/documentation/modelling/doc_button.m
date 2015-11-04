%% Button
%
% Outputs 1 if the button is pressed, 0 otherwise.
%
%% Description
% 
% <<../img/Modelling/button.PNG>>
%
% Uses the Engduino's push button to detect whether a button is pressed.
% 
%% Example
%
% This model lights up LED 0 when the button is pressed.   
%
% <<../img/Modelling/buttonExample.PNG>>  
%
% It first compare the output value from the *button* block, if it is
% greater than zero(button is pressed), then it will select *if action
% subsystem* block. The constant value will then be passed to the *rgb_led*
% block. The *merge* block allows the signal from both subsystem to be
% passed to the *rgb_led* block, but only one signal will be active at a
% time.
%
%% Data type
% Output data type is uint8_t
