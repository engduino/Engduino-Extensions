function uploadToEngduino(hexFile, engduinoPath)

% Function to upload a hexfile to the Engduino. This has two steps:
% 1. Open the COM port at 1200 bps to reset bootloader
% 2. Call AVRDuDE to upload program to flash

if nargin < 2
    % Hard-code the path here for convenience
    engduinoPath = 'C:\Program Files\Arduino-Engduino\';
end

% Find the virtual COM port of the Engduino
serial_port = searchForComPort;

disp('### Setting the Engduino to upload mode')
disp(['### Opening ', serial_port])

% Soft reset to prepare for upload
% (serial connection at 1200)
resetEngduino(serial_port);

disp('### Finding upload port')

tic;
% Find the new COM port when it appears
avrdude_port = searchForComPort;
while (strcmp(serial_port, avrdude_port) || isempty(avrdude_port)) && toc < 5
    pause(0.1);
    avrdude_port = searchForComPort;
end
    
% Create command to call AVRDuDE
cmd = callAVRDude(engduinoPath, avrdude_port, hexFile);
disp(cmd);

% Upload hex file
disp(['### Connecting to ' avrdude_port]);
disp(['### If your target board has TX and RX LED you should '...
    'see them flashing ... ']); 

[ww, w] = system(cmd);

disp(w)
disp(ww)
disp('end')
end

function cmd = callAVRDude(engduinoPath, avrdude_port, hexFile, mcu, avrdude_programmer, uploadRate)
% Normal usage is to pass the path to the Engduino installation and the
% upload port to the function. The default values for the MCU, flash
% protocol and upload rate can be overridden if necessary.

if nargin < 4
    % Default settings for the Engduino
    mcu = 'atmega32u4';
    avrdude_programmer = 'avr109';
    uploadRate = '57600';
end

avrPath = fullfile(engduinoPath, 'hardware', 'tools', 'avr');
avrPath = strrep(avrPath, '\', '/');

% path to avrdude configuration file and application
avrdude_conf = sprintf('"%s/etc/avrdude.conf"', avrPath);
avrdude =  sprintf('"%s/bin/avrdude"', avrPath);

% settings for AVRDude upload tool
avrdude_flags = sprintf('-C %s -p %s -P //./%s -c %s -b %s -D -U flash:w:%s',...
    avrdude_conf, mcu, avrdude_port, avrdude_programmer, uploadRate, hexFile);

cmd = sprintf('%s %s',avrdude, avrdude_flags);

end
        
function resetEngduino(avrdude_port)
% Communicating with the ATMega32u4 at 1200 bps will switch it into upload
% mode
  s = serial(avrdude_port, 'BaudRate', 1200);
  fopen(s);
  fclose(s);
  delete(s);
end

function ports = searchForComPort(regCmdOutput)
% Find the Engduino COM port by a registery search
ports='';

assert(ispc,'The searchForComPort function is not supported for Linux or Mac')

if nargin < 1
    regCmd=['reg query '...
        'HKEY_LOCAL_MACHINE\HARDWARE\DEVICEMAP\SERIALCOMM'];
    [~,regCmdOutput]=system(regCmd);
end

deviceName='\\Device\\(VCP\d|USBSER\d{3})';
reg_sz = 'REG_SZ';
portNum = 'COM\d+';
expr = [deviceName '\s+' reg_sz '\s+(' portNum ')'];
allPorts=regexp(regCmdOutput,expr,'tokens');
if ~isempty(allPorts)
    ports=cell(1, length(allPorts));
    for j=1:length(allPorts)
        ports{j}=allPorts{j}{2};
    end
    ports = ports{1};
end


end
 