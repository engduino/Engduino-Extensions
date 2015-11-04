%% Find Port Numbers
%
%% Find port number on Windows
% Open Device Manager and expand the Ports (COM & LPT) list.
%
% <<img/device_manager.png>>
%
% Note the number on the *USB Serial Port*.
%
%% Find port number on Macintosh
% Open a Mac Terminal and type:
% 
%       ls /dev/tty*
% 
% Note the port number listed for dev\tty.usbmodem* or
% dev\tty.usbserial*. The port number is represented with * here.
%
%% Find port number in Linux
% Open terminal and type:
%
%       ls /dev/tty*
%
% Note the port number listed for /dev/ttyUSB* or /dev/ttyACM*. The port number is 
% represented with * here.
%
% Create a symbolic link with a standard number:
%
%       ln -s /dev/ttyUSB* /dev/ttyS*
%
% Replace * with a standard port number.
%