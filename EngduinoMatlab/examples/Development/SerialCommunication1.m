%% Serial Communication
% This example code shows how to read data from serial port for those
% that contains value

serialPort = 'COM4';

%% Check for old serial port before creating new one
oldSerial = instrfind('Port','COM4');
if(~isempty(oldSerial))
   fclose(oldSerial);
   delete(oldSerial);
end

serialObject = serial(serialPort);
fopen(serialObject);

while (1)
        reading = fscanf(serialObject);  %#ok<SAGROW>
        temp_str = strsplit(reading,{'\r\n'},'DelimiterType','RegularExpression');
        val = str2double(temp_str(1));
        disp(val);
        pause(timeInterval); 
        count = count +1;
end

%% Clean up the serial object
fclose(serialObject);
delete(serialObject);
clear serialObject;