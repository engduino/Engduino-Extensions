function arduinoLeonardoDownload(h, pjtDir, modelName)
% ARDUINOPREDOWNLOAD Code executed before downloading code
% Copyright 2013 The MathWorks, Inc.

% Get Arduino IDE Root information
[~, arduinoIdeBinDir] = realtime.internal.getArduinoIDERoot('toolsbin');

% Get the Arduino Leonardo flashing utility
if ispc
    DownloadUtility = [fullfile(arduinoIdeBinDir,'avrdude') ' >tmp.trash 2>&1 ']; %fullfile(arduinoIdeBinDir,'avrdude');
else
    DownloadUtility = fullfile(arduinoIdeBinDir,'avrdude');
end    

%Get the download file path
if ispc
    outFile = fullfile(pjtDir, [modelName h.ToolsInfo.DownloadFileExtension]);
    [~, outFile, outExt] = fileparts(outFile);
    outFile = [outFile outExt ':i'];
else
    outFile = fullfile(pjtDir, [modelName h.ToolsInfo.DownloadFileExtension]);
end

% Get the COM port number
tgtData = get_param(modelName, 'TargetExtensionData'); 
    
%For leonardo we need to flash the code onto the board when its in the
%bootloader mode.
%portInfo = realtime.internal.connectAndDownloadToLeonardo(tgtData);
portInfo.COMPort = 'COM15';         % <<<<<<< This is the bootloader port
portInfo.UploadRate = '57600';

if ispc
        COMPort = ['-P //./' portInfo.COMPort];
else
        COMPort = ['-P ' portInfo.COMPort];
end

%Override default baud rate with the new baudrate from the
%arduino custom settings specified by the user
custombaudrate = realtime.internal.getArduinoCustomDownloadBaudRate;
if isempty(custombaudrate)
    downloadbaudrate = '57600';
else
    downloadbaudrate = custombaudrate;
end

if ispc
    DownloadUtilityFlags = ['-V -q -q -q -q -F -C ' fullfile(arduinoIdeBinDir,'..','etc','avrdude.conf') ' -p atmega32u4 -c avr109 -b ' downloadbaudrate ' -D -U flash:w:'];
else
    DownloadUtilityFlags = ['-V -q -q -q -q -F -C ' fullfile(arduinoIdeBinDir,'..','etc','avrdude.conf') ' -p atmega32u4 -c avr109 -b ' downloadbaudrate ' -D -U flash:w:'];
end    

cmd = sprintf('%s %s %s%s', DownloadUtility, COMPort, ...
      DownloadUtilityFlags, outFile);

if ~ispc
cmd = [cmd '&']; %This is needed to make sure that download verbose logs do not show up on the diagnostic viewer.
end

portObj = serial('COM14','BaudRate',1200);      % <<<<<<< This is the Lilypad port
fopen(portObj);
fclose(portObj);
pause(4);

if system(cmd)
    error(message('arduino:build:ConnectError'));
end

end