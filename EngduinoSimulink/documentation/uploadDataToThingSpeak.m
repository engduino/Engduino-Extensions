%% Get temperature from Temperature Serial block and upload data to ThingSpeak
% This example shows how to get data through the *temperature
% serial* block implemented in Simulink and upload to ThingSpeak.
% The MATLAB code get the value of the temperature sensor
% through serial communication and upload to ThingSpeak.
% To run this example. implement the *temperature serial* block into your
% model and deploy it to Engduino, then run this code in MATLAB.

%% Intialization

% ChId of the channel
writeChId = 54313;
% WriteKey of the channel
writeKey = 'A40IJ3Q0H3PL3IJG';

% Specify the serial port
serialPort = 'COM4';
% to get sensor data from serial
getLightStr = 'Light value: ';
getTempStr = 'Temperature value: ';
getDataStr = 'Data value: ';

%% Check for old serial port before creating new one
oldSerial = instrfind('Port','COM4');
if(~isempty(oldSerial))
   fclose(oldSerial);
   delete(oldSerial);
end

serialObject = serial(serialPort);
fopen(serialObject);

time = now;
temperature = 0;
timeInterval = 0.1;
count =0;
%% Collect data
while (1)
        reading = fscanf(serialObject); 
        % split the string by cr+lf, it returns the value and a ''
        strSplitted = strsplit(reading,{'\r\n'},'DelimiterType','RegularExpression');
        % search for the string that contains temperature value
        temperature=strfind(strSplitted,getTempStr);
        % if the string contains temperature value
        if(not(isempty(temperature{1})))
            str = strjoin(strSplitted(1));
            % separate the string and temperature data
            strSplitted2 = strsplit(str,{getTempStr},'DelimiterType','RegularExpression');
            % convert the temperature data from string to double
            temp = str2double(strSplitted2{2});
            temperature = temp;
        end
        % get current time
        c = clock;
        t = datetime(c(1),c(2),c(3),c(4),c(5),c(6));
        %% Upload data to thingspeak
        if count>150
            % channelID,data, fields eg.[1,2,3]
            thingSpeakWrite(writeChId, temperature, 'Fields',[1],'TimeStamps',t,'Writekey',writeKey);
            count = 0;
        end
        pause(timeInterval);
        count = count+1;
end
%% Clean up the serial object
fclose(serialObject);
delete(serialObject);
clear serialObject;