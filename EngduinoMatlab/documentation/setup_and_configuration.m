%% Setup and Configuration Guide
% Install software and setup hardware connection.
% 
%% Required Software
% * Arduino-Engduino IDE v1.6.0
% * MATLAB Support Package for Engduino hardware
% 
%% 1. Install Arduino-Engduino IDE
%
% You will need to flash the Engduino hardware with a program that come with the Arduino-Engduino IDE in order for
% MATLAB to communicate with the board. If you already have a working IDE to program the Engduino, you may skip
% to step 2.
%
% *For Windows* 
%
% * <http://www.engduino.org/download/windows_installer_3264_bits/ 32/64
% bit installer (Release V3.1.1 for Engduino v1,2 and 3)>
%
% *For Mac*
%
% * <http://www.engduino.org/download/mac_uncompressed/ 32/64
% bit installer (Release V3.1.1 for Engduino v1,2 and 3)>
%
% *Note:* For other installation method, please refer to the
% Official Engduino Website <http://www.engduino.org/index.php?id=7385 here>.
%
%% 2. Flash the Engduino hardware
% Once you have installed the installer package using the above method, your computer should  
% have the drivers, Arduino files and Engduino Libraries installed. 
%
% Launch the Arduino-Engduino IDE, go to *File*-> *Examples* ->
% *100.Engduino* -> *Protocol* to locate the program.
%
% <<img/engduino_flash_ide.png>>
%
% Connect the Engduino hardware to the computer via USB and upload the *Protocol.ino*
% program to the Engduino hardware. 
%
% If it fails to upload the program, make sure that you have selected the
% correct COM port for the Engduino hardware under *Tools* -> *Port* and the version of the Engduino hardware under *Tools* -> *Board* in the
% IDE.
%
%% 3. Connect Engduino hardware in MATLAB
% After you have flashed the Engduino hardware with the above program, you may
% follow the tutorial on how to connect the Engduino board in MATLAB.
% 
% * <connect_to_engduino.html Connect to Engduino Hardware>
% * <find_port_numbers.html Find Port Numbers>
%