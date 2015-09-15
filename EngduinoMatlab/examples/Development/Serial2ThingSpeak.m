%% Real time data collection example
% This MATLAB code read in the serial and convert the value into numbers
% and upload to thingSpeak. For this function to work, please install
% thingspeak matlab toolbox

% ChId of the channel
writeChId = 54313;
% WriteKey of the channel
writeKey = 'A40IJ3Q0H3PL3IJG';

serialPort = 'COM4';

%% Check for old serial port before creating new one
oldSerial = instrfind('Port','COM4');
if(~isempty(oldSerial))
   fclose(oldSerial);
   delete(oldSerial);
end

serialObject = serial(serialPort);
fopen(serialObject);

%% Set up the figure window
time = now;
temperature = 0;

timeInterval = 0.1;

%% Collect data
count = 0;

while (1)
  
        reading = fscanf(serialObject);  %#ok<SAGROW>
        
        % split the string by cr+lf, it returns the value and a ''
        strSplitted = strsplit(reading,{'\r\n'},'DelimiterType','RegularExpression');
        % convert the value to double
        temp = str2double(strSplitted(1));
        disp('Temperature');
        disp(temp);
        
        c = clock;
        t = datetime(c(1),c(2),c(3),c(4),c(5),c(6));
        if count>150
            % channelID,data, fields eg.[1,2,3]
            thingSpeakWrite(writeChId, temp, 'Fields',[1],'TimeStamps',t,'Writekey',writeKey);
            count = 0;
        end
        pause(timeInterval);
        
        count = count +1;
    
end

%% Put the instrument in local mode
% fprintf(serialObject,'SYSTEM:LOCAL');

%% Clean up the serial object
fclose(serialObject);
delete(serialObject);
clear serialObject;