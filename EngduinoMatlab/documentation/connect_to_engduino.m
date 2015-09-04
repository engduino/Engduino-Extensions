%% Connect to Engduino Hardware
%
% This example shows how to connect Engduino hardware in MATLAB.
%
% Make sure that the Engduino hardware is flashed with the *Protocol.ino* 
% program and it is connected to the computer. 
%
% Launch MATLAB, include the path to the *lib* folder that come with the _MATLAB Support Package for Engduino Hardware_. Launch MATLAB and create a new script.
%
% Connect to the Engduino hardware via USB. Refer <find_port_numbers.html
% here> to find the port number.

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
    % Create Engduino object and open COM port. You do not need to select
    % an active COM port, as it should be detected automatically. However,
    % in the case of unsuccessful connection, you may initialize Engduino
    % object with passing the active COM port. E.g. e = engduino('COM8');
    % To open the 'Bluetooth' port you need to initialize the Engduino
    % object with the 'Bluetooth' keyword and your Bluetooth device name.
    % E.g. e = engduino('Bluetooth', 'HC-05'); Demo mode can be enabled by
    % initialize the Engduino object with 'demo' keyword. E.g. e =
    % engduino('demo');
    e = engduino();
end


%%
% *Note:* If you receive an error message
%
% <<img/engduino_connection_error_msg.png>>
%
% Please try to re-run the code again for a few times. If the problem persists, try to turn off/on the Engduino hardware, unplug
% and re-plug the USB cable, or try to restart MATLAB while keeping the hardware connected to the computer.
%
%%
% You should see the message below when the Engduino hardware is successfully connected
% in MATLAB
%
% <<img/engduino_connection_successful_msg.png>>
%
% You may proceed to the included examples <matlab_support_package_engduino_example.html here> to jump start your
% development with Engduino hardware in MATLAB.