%% Get temperature from Temperature Serial block
% This example shows how to get data through the *temperature
% serial* block implemented in Simulink.
% The MATLAB code get the value of the temperature sensor
% through serial communication.
% To run this example. implement the *temperature serial* block into your
% model and deploy it to Engduino, then run this code in MATLAB.

%% Intialization

% Specify the serial port
serialPort = 'COM4';
getLightStr = 'Light value: ';
getTempStr = 'Temperature value: ';

%% Check for old serial port before creating new one
oldSerial = instrfind('Port','COM4');
if(~isempty(oldSerial))
   fclose(oldSerial);
   delete(oldSerial);
end

serialObject = serial(serialPort);
fopen(serialObject);
timeInterval = 0.1;

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
            disp(temp);
        end
        pause(timeInterval);
end
%% Clean up the serial object
fclose(serialObject);
delete(serialObject);
clear serialObject;