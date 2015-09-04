%% Cannot Connect to Engduino Hardware
%
% MATLAB should auto detect the port connected to the hardware on Windows.
% If MATLAB cannot detect the Engduino, make sure that you have flashed the
% Protocol program on the Engduino hardware.
%
% *Check Hardware Connection*
% 
% Make sure that the device manager display the Arduino LilyPad USB
%
% <<img/device_manager.png>>
%
% If the hardware is not listed. Try turn on/off the Engduino hardware or re-plugin the USB.
% You may try to restart the computer. If it does not work, try reinstall
% the driver. It may also be a hardware failure. 
%
% *Manual disconnect*
% 
% If you have manually disconnected the board and reconnected, 
% clear the Engduino object from the MATLAB workspace before you reconnect.