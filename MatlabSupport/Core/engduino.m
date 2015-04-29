classdef engduino < handle
    % This class defines an "engduino" object
    % Engduino team: support@engduino.org, June 2014, Copyright 2014 UCL -
    % University College London
    
    % Defines
    properties (Constant = true, Hidden = true)
        
        % Communication type
        COMM_COMPORT =      1	% ComPort
        COMM_BLUETOOTH =	2	% Bluetooth
        COMM_DEMO =         100	% Demo

        % Board Versions
        ENGDUINOV1_0_SKETCH_BASIC = 10
        ENGDUINOV2_0_SKETCH_BASIC = 20
        ENGDUINOV3_0_SKETCH_BASIC = 30   % Basic sketch
        
        % Commands
        COM_SET_LEDS =                  10
        COM_SET_LED	=                   11
        COM_SET_PINS_DIGITAL_TYPE =     20
        COM_SET_PINS_ANALOG_TYPE =      21
        COM_SET_PINS_DIGITAL_VALUE =	22
        COM_SET_PINS_ANALOG_VALUE =     23
        COM_SET_STATUS =                90
        COM_GET_VERSION =               100
        COM_GET_SENSORS =               110
        COM_GET_TEMPERATURE =           111
        COM_GET_ACCELEROMETER =         112
        COM_GET_MAGNETOMETER =          113
        COM_GET_LIGHT =                 114
        COM_GET_BUTTON =                120
        COM_GET_PINS_DIGITAL_VALUE =	130
        COM_GET_PINS_ANALOG_VALUE = 	131
        COM_GET_STATUS =                190

        % Package
        PACKAGE_START_CHR	=	'{'
        PACKAGE_STOP_CHR	=	'}'
        PACKAGE_DELIMITER_CHR =	';'
        
        % Package Type
        PACKAGE_TYPE_1 = 1
        PACKAGE_TYPE_2 = 2
        PACKAGE_TYPE_3 = 3
        
        % Sensor Type
        SENSOR_ALL =	0
        SENSOR_TEMP =	1
        SENSOR_ACC =	2
        SENSOR_MAG =	3
        SENSOR_LIGHT =  4
        
        % Button
        BUTTON_PRESSED =    1
        BUTTON_RELEASED =   2
       
        % Result codes
        RES_OK =   0
        RES_ERR	= -1
        
        % Serial communication
        SERIAL_DEFAULT_BAUDRATE = 9600
        
        % Leds
        LED_COUNT = 16
        LED_DEFAULT_COLOR = 7
        LED_DEFAULT_BRIGHTNESS = 0
    end
    
    % Defines visable
    properties (Constant = true, Hidden = false)
        % Colours
        COLOR_RED =     0
        COLOR_GREEN =   1
        COLOR_BLUE =    2
        COLOR_YELLOW =  3
        COLOR_MAGENTA = 4
        COLOR_CYA =     5
        COLOR_WHITE =   6
        COLOR_OFF =     7 
        
        % IO Pins
        PIN_TYPE_INPUT =    0
        PIN_TYPE_OUTPUT =   1
        PIN_VALUE_LOW =     0
        PIN_VALUE_HIGH =    1
        
        % Status
        STATUS_OVERSAMPLING = 0	% Enable internal oversampling
    end
    
    properties (SetAccess=private, GetAccess=private)
        comm   % Communication type
        aser   % Serial Connection
        pins   % Pin Status Vector
        bver   % Board Version
        port   % Active Serial port
    end
    
    properties (Hidden=true)
        chks = true;  % Checks serial connection before every operation
        chkp = true;  % Checks parameters before every operation
    end
    
    properties (Hidden=false)
        header = struct('packageType', 1, 'commandID', -1, 'packageID', 0, 'ack', 0);   % Default header structure
        leds = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_COLOR;                 % Holds current Leds states
        ledsB = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;           % Holds current Leds brightness
        leds_rgb = zeros(engduino.LED_COUNT, 3);                                        % Holds current Leds brightness for each colour
        leds_r = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
        leds_g = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
        leds_b = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
        
        serialProperties = struct('Parity', 'none', 'DataBits', 8, 'FlowControl', 'none', 'Terminator', engduino.PACKAGE_STOP_CHR);
        showErrorEnable = 1;
        
        callbackEnable = true;
        asyncButton = false;
        asyncSensors = false;
        
        buttonWasPressed = false;
        buttonWasReleased = false;
        
        % Asynchronous callbacks to the upper code level, e.g.: GUI
        callback_sensors = @(temp, accel, mag_field, light, samples) disp('');
        callback_button = @(state) disp('');
    end
    
    % Internal variables
    properties (Hidden = true, SetAccess = protected, GetAccess = protected)
        leds_r_ = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
        leds_g_ = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
        leds_b_ = ones(1, engduino.LED_COUNT).*engduino.LED_DEFAULT_BRIGHTNESS;
    end

    % Demo variables
    properties (Hidden=true)
        temperature = 25 + randn();
        
        % Magnetomter value is represented by phi and theta on an elipsoid.
        magnetometer = [2*randn(), 2*randn()]; 
        
        % Accelerometer value is represented by phi and theta on an elipsoid.
        accelerometer = [2*randn(), 2*randn()];
    end
    
    methods
        % constructor, connects to the board and creates an arduino object
        function e = engduino(port, param1)
            % e = engduino(port, param1)
            % Creates an Engduino object with selected communication type.
            % Available communications are [Com, Bluetooth].
            %
            % Examples:
            % e = engduino('COM47'); % Opens ComPort communication
            % on port COM47 with the default 9600 baudrate.
            %
            % e = engduino('COM47', 115200); % Opens ComPort communication
            % on port COM47 with the 115200 baudrate.
            %
            % e = engduino(); % Automatically search over the available COM
            % ports any try to connect on one.
            % 
            % e = engduino('Bluetooth', 'HC-05'); % Opens Bluetooth 
            % communication with the device 'HC-05'.
            
            % Parse input parameters and define the type of communication
            e.comm = -1;
            if (nargin == 0), port = 'dummy'; end;
            if (strcmp(port, 'Bluetooth'))
                if (nargin ~= 2), error('Wrong input parameters!'); end
                e.comm = e.COMM_BLUETOOTH;
            elseif (strcmpi(port, 'demo') || strcmpi(port, 'd'))
                if (nargin ~= 1), error('Wrong input parameters!'); end
                e.comm = e.COMM_DEMO;
            else
                e.comm = e.COMM_COMPORT;
                switch nargin
                    case {0,1}
                        baudRate = e.SERIAL_DEFAULT_BAUDRATE;
                    case 2
                        baudRate = param1;
                    otherwise
                        error('Wrong input parameters!');
                end
            end

            % Open port on defined comminication channel
            switch e.comm
                case e.COMM_COMPORT
                    % check port
                    if ~ischar(port),
                        error('The comPort input argument must be a string, e.g. ''COM8'' ');
                    end

                    % check baud rate
                    if (~ismember(baudRate, [9600, 19200, 38400, 57600, 115200])), 
                        error('The baudRate input argument must be a valid serial speed from list [9600, 19200, 38400, 57600 or 115200] bit/s ');
                    end

                    if (nargin == 0) % Get all available ports
                        ports = GetAvailableComPorts();
                    else
                        ports = {port};
                    end
                    
                    e.showErrorEnable = 0; % Disable error log during searching for valid serial port.
                    %warning('off', 'MATLAB:serial:fscanf:unsuccessfulRead'); % Hide Matlab warning.
                    e.bver = []; % Clear variable.
                    disp('>>> Searching for Serial ports...')
                    for i=1:numel(ports) % Loop over ports
                        % Search for exsisting ports.
                        e.aser = instrfind('Type', 'serial', 'Port', ports{end-(i-1)});

                        % Create the serial port object if it does not exist 
                        % otherwise use the object that was found.
                        if isempty(e.aser)
                            % Define serial object.
                            e.aser = serial(ports{end-(i-1)}, 'BaudRate', baudRate, e.serialProperties);
                        else
                            % Use the object that was found.
                            fclose(e.aser);
                            e.aser = e.aser(1);
                        end
                        
                        try
                            e.aser.Timeout = 0.5;
                            e.aser.BytesAvailableFcnMode = 'terminator';
                            e.aser.BytesAvailableFcn = @e.serialCallback;
                            fopen(e.aser);
                            flush(e);                   % Flush serial buffer before sending anything.
                            e.bver = e.getVersion();    % Query sketch type.
                            if ~isempty(e.bver)         % Engduino board found
                                e.port = ports{end-(i-1)};
                                break;
                            end 
                        catch
                            delete(e.aser); % Delete object and try another one. 
                        end
                    end
                    e.showErrorEnable = 1; % Enable back error log.
                    warning('on', 'MATLAB:serial:fscanf:unsuccessfulRead'); % Show Matlab warning.
                
                case e.COMM_BLUETOOTH
                    % Create the Bluetooth object
                    disp('>>> Opening Bluetooth port...')
                    e.aser = Bluetooth(param1, 1, 'Terminator', e.PACKAGE_STOP_CHR);
                    try
                        e.aser.BytesAvailableFcnMode = 'terminator';
                        e.aser.BytesAvailableFcn = @e.serialCallback;
                        fopen(e.aser);
                        flush(e); % Flush serial buffer before sending anything.
                        e.bver = e.getVersion(); % Query sketch type.
                        e.port = 'Bluetooth';
                    catch
                        delete(e.aser);
                     end
                    
                case e.COMM_DEMO
                    % Create the Demo object
                    e.port = 'Demo';
                   
                otherwise
                    error('Unknown communication type selected! Chose between: [Serial, Bluetooth]') 
            end

            % Connect - open port
            if e.comm ~= e.COMM_DEMO
                if isempty(e.bver)
                    fprintf([ ...
                        'Connection unsuccessful, please make sure that the board is powered on,\n'...
                        'running a sketch provided with the package, and detected by\n'...
                        'the operating system as a serial port.\n'...
                        'Then restart Matlab, it only scans for hardware devices on startup.\n'...
                        'You might also try to unplug and re-plug the USB cable.\n\n']);
                    switch e.comm
                        case e.COMM_COMPORT
                            aports = GetAvailableComPorts();
                            disp('>>> Available ports: ');
                            disp(aports);
                            error(['Could not open port: ' port]);

                        case e.COMM_BLUETOOTH
                            disp('>>> Available Bluetooth devices: ');
                            names = instrhwinfo('Bluetooth');
                            disp(names.RemoteNames);
                            error(['Could not open Bluetooth connection with device: ' param1]);
                    end
                    delete(e);
                end
                
                % Chech for the sketch version.
                switch e.bver
                   case e.ENGDUINOV3_0_SKETCH_BASIC
                      disp('>>> Basic Engduino V3.0 sketch detected!');
                   otherwise
                      delete(e);
                      error('Unknown sketch or device. Please make sure that a sketch provided with the package is running on the board');
                end
            else
                disp('>>> Engduino open in Demo mode!');
            end

            % notify successful installation
            disp(['>>> Engduino successfully connected on port: ' '' e.port '' '!']);
            
        end % engduino
        
        % Called when package received
        function serialCallback(e, obj, event)
            if(e.callbackEnable == false), return; end;
            if (e.asyncButton == true || e.asyncSensors == true)
                content = fscanf(e.aser);
                %disp(['content2: ' content]);
                
                % Parse package
                [h, v] = e.parsePackage(content);
                
                % Check received package
                switch h.commandID 
                    case e.COM_GET_BUTTON
                        if(v(1) == e.BUTTON_PRESSED)
                            e.buttonWasPressed = true;
                        elseif(v(1) == e.BUTTON_RELEASED)
                            e.buttonWasReleased = true;
                        end
                        e.callback_button(v(1));
                        
                    case e.COM_GET_SENSORS
                        temp = v(1)/1000;
                        accel = v(2:4)./1000;
                        mag_field = v(5:7);
                        light = v(8);
                        samples = v(9);
                        e.callback_sensors(temp, accel, mag_field, light, samples);
                    
                    otherwise 
                        e.showError('serialCallback ERROR: Wrong command ID!');
                end
            end
        end
        
        % distructor, deletes the object
        function delete(e)
            % Use delete(e) or e.delete to delete the arduino object
            % if it is a serial, valid and open then close it
            if isa(e.aser, 'serial') && isvalid(e.aser) && strcmpi(get(e.aser, 'Status'), 'open'),
                fclose(e.aser);
            end
            
            % if it's an object delete it
            if isobject(e.aser),
                delete(e.aser);
            end
        end % delete
        
        % disp, displays the object
        % TO-DO When we will have engduino help, update the links!
        function disp(e)
            
            % disp(e) or e.disp, displays the arduino object properties
            % The first and only argument is the arduino object, there is no
            % output, but the basic information and properties of the arduino
            % object are displayed on the screen.
            % This function is called when just the name of the arduino object
            % is typed on the command line, followed by enter. The command
            % str=evalc('e.disp'), (or str=evalc('e')), can be used to capture
            % the output in the string 'str'.
            
            if isvalid(e),
                if isa(e.aser,'serial') && isvalid(e.aser),
                    disp(['<a href="matlab:help engduino">engduino</a> object connected to ' e.aser.port ' port']);
                    
                    switch e.bver
                       case e.ENGDUINOV3_0_SKETCH_BASIC
%                           disp('Basic Analog & Digital I/O sketch (adio.pde) running on the board');
%                           disp(' ');
%                           e.pinMode
%                           disp(' ');
%                           disp('Pin IO Methods: <a href="matlab:help pinMode">pinMode</a> <a href="matlab:help digitalRead">digitalRead</a> <a href="matlab:help digitalWrite">digitalWrite</a> <a href="matlab:help analogRead">analogRead</a> <a href="matlab:help analogWrite">analogWrite</a> <a href="matlab:help analogReference">analogReference</a>');
%                           disp(' ');
%                           disp('Serial port and other Methods: <a href="matlab:help serial">serial</a> <a href="matlab:help flush">flush</a> <a href="matlab:help roundTrip">roundTrip</a>');

                        otherwise
                          error('Unknown sketch or device!');
                    end
                    disp(' ');
                else
                    disp('<a href="matlab:help engduino">engduino</a> object connected to an invalid serial port');
                    disp('Please delete the engduino object');
                    disp(' ');
                end
            else
                disp('Invalid <a href="matlab:help engduino">engduino</a> object');
                disp('Please clear the object and instantiate another one');
                disp(' ');
            end
        end
        
        % serial, returns the serial port
        function str = serial(e)
            
            % serial(e) (or e.serial), returns the name of the serial port
            % The first and only argument is the arduino object, the output
            % is a string containing the name of the serial port to which
            % the arduino board is connected (e.g. 'COM9', 'COM47', or
            % '/dev/ttyS101'). The string 'Invalid' is returned if
            % the serial port is invalid
            
            if isvalid(e.aser),
                str = e.aser.port;
            else
                str = 'Invalid';
            end
            
        end  % serial
        
        % flush, clears the pc's serial port buffer
        function val = flush(e)
            
            % val=flush(e) (or val=e.flush) reads all the bytes available 
            % (if any) in the computer's serial port buffer, therefore 
            % clearing said buffer.
            % The first and only argument is the arduino object, the 
            % output is a vector of bytes that were still in the buffer.
            % The value '-1' is returned if the buffer was already empty.
            
            val=-1;
            if e.aser.BytesAvailable>0,
                val=fread(e.aser, e.aser.BytesAvailable);
            end
        end  % flush
        
        function showError(e, str)
            if (e.showErrorEnable)
                disp(str);
            end
        end
        
        function mode = isDemoMode(e)
            % Return true if Engduino is in "demo mode".
            mode = false;
            if(e.comm == e.COMM_DEMO)
                mode = true;
            end
        end
        
    end % methods

    % Core protocol functions
    methods (Hidden=true) % internal methods
        
        % Wait on response
        function content = waitOnResponse(e)
            content = fscanf(e.aser); % Reads entire line until delimiter character.
            %disp(['content: ' content]);
        end
        
        % Parse received package
        function [header, vals] = parsePackage(e, content)
            % Returns package header and values 
            
            % Initialize variables
            vals = [];
            header = struct('packageType', -1, 'commandID', -1, 'packageID', -1, 'ack', -1);
            
            if(length(content) < 1)
                e.showError('parsePackage ERROR: No contend received!');
                return;
            end
            
            if(content(1) ~= '{') 
                e.showError(['parsePackage ERROR: Start character not detected!  Content -> ' content]);
                return;
            end
            content = content(2:end-1); % Remove start and stop character.
            splitCells = strsplit(content, e.PACKAGE_DELIMITER_CHR);
            vals = str2double(splitCells);
            nrOf = length(vals);
            
            if(nrOf < 1) 
                e.showError(['parsePackage ERROR: Not enough values in the received package! Content -> ' content]);
            end
            
            % Parse header
            header.packageType = vals(1);
            
            switch header.packageType 
                case e.PACKAGE_TYPE_1
                    if(nrOf < 2) 
                        e.showError(['parsePackage ERROR: Parse header error!  Content -> ' content]);
                        return;
                    end
                    header.packageType = e.PACKAGE_TYPE_1;
                    header.commandID = vals(2);
                    vals = vals(3:end);
                    
                case e.PACKAGE_TYPE_2
                    if(nrOf < 4) 
                        e.showError(['parsePackage ERROR: Parse header error!  Content -> ' content]);
                        return;
                    end
                    header.packageType = e.PACKAGE_TYPE_2;
                    header.commandID = vals(2);
                    header.packageID = vals(3);
                    header.ack =       vals(4);
                    vals = vals(5:end);
                    
                 otherwise 
                    e.showError(['parsePackage ERROR: Unknown package type!  Content -> ' content]);
            end
        end
    
        % Send package
        function sendPackage(e, vals)
            if(e.comm == e.COMM_DEMO), return; end; % Don't do anything if we are in "demo" mode.
            switch e.header.packageType 
                case e.PACKAGE_TYPE_1
                    
                    s = [e.PACKAGE_START_CHR num2str(e.header.packageType) e.PACKAGE_DELIMITER_CHR num2str(e.header.commandID)];
                    for i=1:length(vals)
                        s = [s e.PACKAGE_DELIMITER_CHR num2str(vals(i))];
                    end
                    s = [s e.PACKAGE_STOP_CHR]; % Add stop character
                    %disp(['PACKAGE:' s]);
                    fwrite(e.aser, s); % Send package
                    
                case e.PACKAGE_TYPE_2
                    % TO-DO implement another version
                    e.showError('Not implemented!');
                    
                otherwise 
                    e.showError(['sendPackage ERROR: Unknown package type!  Content -> ' e.header]);
            end
        end
    end
    
    % Commands
    methods (Hidden=false) % internal methods
        
        % Set Led
        function res = setLed(e, val)
            % Turn on or off Led on the device.
            %
            % INPUTS
            % val = 0 -> Turn Led off
            % val = 1 -> Turn Led on
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setLed(1); % Turns Led on
            
            % Check parameters
            if (length(val) ~= 1), 
                e.showError('setLed ERROR: Wrong number of input values! Should be size of 1.');
                res = e.RES_ERR;
                return;
            end
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr=engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % set header parameters
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_LED;
            
            % send package
            e.sendPackage(val); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
        % Set Leds
        function res = setLeds(e, vals)
            % res = setLeds(e, vals)
            % Set colors of all 16 RBG Leds on the device
            %
            % INPUTS
            % vals[1-16] = [color1, .... , color16]
            %
            % Colors are defined as:
            % RED =     0
            % GREEN =   1
            % BLUE =    2
            % YELLOW =  3
            % MAGENTA = 4
            % CYA =     5
            % WHITE =   6
            % OFF =     7
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setLeds([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, 1]);
            % setLedsAll(e.COLOR_BLUE, e.COLOR_YELLOW, ... , e.COLOR_CYA);
            
            % Check parameters
            if (length(vals) ~= 16), 
                e.showError('setLeds ERROR: Wrong number of input values! Should be size of 16.');
                res = e.RES_ERR; return;
            end
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_LEDS;
            
            e.sendPackage(vals); % Send package without parameters

            e.leds = vals;  % Save current Leds states
            res = e.RES_OK; % Dummy set of result parameter
        end
        
        % Set Leds
        function res = setLedsB(e, colours, brightness)
            % res = setLedsB(e, colours, brightness)
            % Set colours and brightness of all 16 RBG Leds on the device
            % Colours are standard as in function 'setLeds'.
            % Brightness goes from 0-15.
            %
            % INPUTS
            % colours[1-16] = [color1, .... , color16]
            % brightness[1-16] = [brigh1, .... , brigh16]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setLeds([0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1, 0, 1], ...
            %         [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]);
            
            % Check parameters
            if (length(colours) ~= 16 || length(brightness) ~= 16), 
                e.showError('setLeds ERROR: Wrong number of input values! Should be size of 2x16.');
                res = e.RES_ERR; return;
            end
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % set header parameters
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_LEDS;
            
            % send package
            e.sendPackage([colours, brightness]);
            
            % save current Leds states
            e.leds = colours; 
            e.ledsB = brightness;
            
            % set the function retutn status
            res = e.RES_OK;
        end
        
        % Set Leds with RGB brightness
        function res = setLedsRgb(e, brightness)
            % res = setLedsB(e, vals, valsB)
            %
            % INPUTS
            % brightness(16, 3) = [r1, g1, b1; r2, g2, b2; ...; r16, g16, b16]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            
            % Check parameters
            if (numel(brightness) ~= 3*e.LED_COUNT), 
                e.showError('setLedsRGB ERROR: Wrong number of input values! Should be array size of 16x3.');
                res = e.RES_ERR; return;
            end
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % set header parameters
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_LEDS;
            
            % send package
            e.sendPackage(reshape(brightness', 1, numel(brightness)));
            
            % save current Leds states
            e.leds_rgb = brightness;
            e.leds_r_= brightness(:, 1)';
            e.leds_g_= brightness(:, 2)';
            e.leds_b_= brightness(:, 3)';
            
            % set the function retutn status
            res = e.RES_OK;
        end
        
        % Set Leds All
        function res = setLedsAll(e, ledsColor)
            % res = setLedsAll(e, ledsColor)
            % Set the same color of all 16 RBG Leds on the device.
            %
            % Examples:
            % setLedsAll(e.COLOR_RED);
            % Sets colors on all 16 RGB Leds.
            
            % Check parameters
            if (length(ledsColor) ~= 1), 
                e.showError('setLedsAll ERROR: Wrong number of input values! Should be size of 1.');
                res = e.RES_ERR; return;
            end
            
            vals = repmat(ledsColor, 1, 16);
            res = e.setLeds(vals);
        end
        
        % Set Leds One
        function res = setLedsOne(e, ledNr, color)
            % res = setLedsOne(e, ledNr, color)
            % Set the color of one Led.
            % Other Leds remains previous states.
            %
            % Examples:
            % setLedsAll(10, e.COLOR_BLUE); % Sets colour only on tenth Led.
            
            % Check parameters
            if (length(ledNr) ~= 1 || length(color) ~= 1), 
                e.showError('setLedsOne ERROR: Wrong number of input values! Should be size of 1.');
                res = e.RES_ERR; return;
            end
            
            if (ledNr < 0 || ledNr > 15), 
                disp('setLedsOne ERROR: Input parameter ledNr out of range [0-15]!');
                res = e.RES_ERR; return;
            end
            
            vals = e.leds;
            vals(ledNr+1) = color;
            res = e.setLeds(vals);
        end
        
        % Set Leds Exact
        function res = setLedsExact(e, leds, ledsColor)
            % res = setLedsExact(e, leds, ledsColor)
            % Set the colors of specified "leds". Other Leds will be turned
            % OFF.
            %
            % Examples:
            % setLedsAll([0, 7, 12], [e.COLOR_RED, e.COLOR_BLUE, e.COLOR_GREEN]);
            % Sets specified color on the 0, 7 and 12 Leds. Rest of them
            % will be set on OFF.
            
            % Check parameters
            if (length(leds) ~= length(ledsColor)), 
                e.showError('setLedsExact ERROR: Length of the input arrays must be the same!');
                res = e.RES_ERR; return;
            end
            
            if (sum(leds < 0) > 0 || sum(leds > 15) > 0), 
                e.showError('setLedsExact ERROR: Input parameter leds out of range [0-15]!');
                res = e.RES_ERR; return;
            end
            
            leds = leds + ones(1, length(leds));    % Add one, because Matlab has starting index 1 instead 0.
            vals = ones(1,16).*e.COLOR_OFF;         % Reset colors to OFF.
            vals(leds) = ledsColor;                 % Update only specified Leds.
            res = e.setLeds(vals);
        end
        
        % Set Status
        function res = setStatus(e, vals)
            % Set status settings
            % All parameters must be specified as KEY-VALUE pair.
            %
            % INPUTS
            % val = [KEY1, VALUE1; KEY2, VALUE2; ... ; KEYn, VALUEn]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setStatus([e.STATUS_OVERSAMPLING, 10]); % Set oversampling rate
            % on 10Hz
            
            % Check parameters
            if (~(size(vals, 2) == 2)) % Array size of the input parameters must be n x 2 
                e.showError('setStatus ERROR: Wrong number of input values! Size of input array must be n x 2.');
                res = e.RES_ERR;
                return;
            end
            
            % Check e.aser for validity if e.chks is true.
            if e.chks,
                errstr=engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_STATUS;
            
            % send package
            e.sendPackage(vals); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
        % Set digital pins type
        function res = setDigitalPinsType(e, vals)
            % Set digital pins type
            % All parameters must be specified as KEY-VALUE pair, where KEY
            % donates to a pin number and VALUE donates to a pin type. Type
            % of the pin can be INPUT or OUTPUT.
            %
            % INPUTS
            % val = [KEY1, VALUE1; KEY2, VALUE2; ... ; KEYn, VALUEn]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setDigitalPinsType([3, e.PIN_TYPE_INPUT; 8, e.PIN_TYPE_OUTPUT]); 
            % Set D3 as a digital input and D8 as a digital output.
            
            % Check parameters
            if (~(size(vals, 2) == 2)) % Array size of the input parameters must be n x 2 
                e.showError('setDigitalPinsType ERROR: Wrong number of input values! Size of input array must be n x 2.');
                res = e.RES_ERR;
                return;
            end
            
            % Check e.aser for validity if e.chks is true.
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_PINS_DIGITAL_TYPE;
            
            % send package
            e.sendPackage(vals); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
        % Set analog pins type
        function res = setAnalogPinsType(e, vals)
            % Set analog pins type
            % All parameters must be specified as KEY-VALUE pair, where KEY
            % donates to a pin number and VALUE donates to a pin type. Type
            % of the pin can be INPUT or OUTPUT.
            %
            % INPUTS
            % val = [KEY1, VALUE1; KEY2, VALUE2; ... ; KEYn, VALUEn]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setAnalogPinsType([1, e.PIN_TYPE_INPUT; 3, e.PIN_TYPE_OUTPUT]); 
            % Set A1 as an analog input and A3 as an analod output.
            
            % Check parameters
            if (~(size(vals, 2) == 2)) % Array size of the input parameters must be n x 2 
                e.showError('setAnalogPinsType ERROR: Wrong number of input values! Size of input array must be n x 2.');
                res = e.RES_ERR;
                return;
            end
            
            % Check e.aser for validity if e.chks is true.
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_PINS_ANALOG_TYPE;
            
            % send package
            e.sendPackage(vals); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
        % Set digital pins value
        function res = setDigitalPinsValue(e, vals)
            % Set digital pins value
            % All parameters must be specified as KEY-VALUE-VALUE blocks, 
            % where KEY donates to a pin number, first VALUE donates to a
            % pin value and second VALUE donates to a pulse width in 
            % milliseconds. Pulse width set on less than 1 millisecond will 
            % set pin unconditionally, where values set on more than 1 will
            % set a pin for a required time interval and after that negate 
            % its state. Value of the digital pin can be HIGH or LOW.
            %
            % INPUTS
            % val = [KEY1, VALUE1_1, VALUE1_2; KEY2, VALUE2_1, VALUE2_2; 
            %       ... ; KEYn, VALUEn_1, VALUEn_2]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setDigitalPinsValue([13, e.PIN_VALUE_HIGH, 0; 6, e.PIN_VALUE_LOW, 1500]); 
            % Set D13 on logical HIGH unconditionally and set D6 on logical
            % LOW for a 1500 millisecond, then negate state to logical
            % HIGH.
            
            % Check parameters
            if (~(size(vals, 2) == 3)) % Array size of the input parameters must be n x 3 
                e.showError('setDigitalPinsValue ERROR: Wrong number of input values! Size of input array must be n x 3.');
                res = e.RES_ERR;
                return;
            end
            
            % Reshape input parameters
            vals = reshape(vals', numel(vals), 1)';
            
            % Check e.aser for validity if e.chks is true.
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_PINS_DIGITAL_VALUE;
            
            % send package
            e.sendPackage(vals); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
         % Set analog pins value
        function res = setAnalogPinsValue(e, vals)
            % Set analog pins value
            % All parameters must be specified as KEY-VALUE-VALUE blocks, 
            % where KEY donates to a pin number, first VALUE donates to a
            % pin value and second VALUE donates to a pulse width in 
            % milliseconds. Pulse width set on less than 1 millisecond will 
            % set pin unconditionally, where values set on more than 1 will
            % set a pin for a required time interval and after that set PWM
            % (duty-cycle) to zero. Value of the analog pin can be between 
            % 0 (always off) and 255 (always on). 
            % Note that for the analog pin can be used any digital pin 
            % including "#" in its name. E.g.: D5#.  
            %
            % INPUTS
            % val = [KEY1, VALUE1_1, VALUE1_2; KEY2, VALUE2_1, VALUE2_2; 
            %       ... ; KEYn, VALUEn_1, VALUEn_2]
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setAnalogPinsValue([13, 123, 0; 6, 75, 1500]); 
            % Set D13# duty-cycle on 123 unconditionally and set D6 
            % duty-cycle on 75 for a 1500 millisecond, then set duty-cycle
            % to 0, which will turn off that pin.
            
            % Check parameters
            if (~(size(vals, 2) == 3)) % Array size of the input parameters must be n x 3 
                e.showError('setDigitalPinsValue ERROR: Wrong number of input values! Size of input array must be n x 3.');
                res = e.RES_ERR;
                return;
            end
            
            % Check e.aser for validity if e.chks is true.
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set header parameters.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_SET_PINS_ANALOG_VALUE;
            
            % send package
            e.sendPackage(vals); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
        
        % Get Version
        function version = getVersion(e)
            % Returns the version of sketch running on device
            
            version = [];
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_VERSION;
            
            e.sendPackage([]); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getVersion ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 1), 
                e.showError(['getVersion ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            version = v(1);
        end
        
        % Get Temperature
        function [temperature, samples] = getTemperature(e)
            % Returns temperature valu in °C
            if e.comm == e.COMM_DEMO
                temperature = e.temperature + randn()*0.01;
                if(mod(floor(now*10^6), 5) == 0), 
                    e.temperature = e.temperature + randn()*1.0;
                end;
                samples = 1;
                return;
            end
            
            temperature = -1;
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_TEMPERATURE;
            
            e.sendPackage([]); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getTemperature ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 2), 
                e.showError(['getTemperature ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            temperature = v(1)/1000; % Devided by 1000, because received value is in mili degrees
            samples = v(2); % Return number of samples taken for this measurement.
        end
        
        % Get Accelerometer
        function [accelerometer, samples] = getAccelerometer(e)
            % Returns acceleration in G
            
            % Initialize output value.
            accelerometer = [-1, -1, -1];
            
            % Predict measurement value if 'Demo' mode is enabled.
            if (e.comm == e.COMM_DEMO)
                e.accelerometer = e.accelerometer + rand(1, 2).*[0.1, 0.1];
                accelerometer = GetPointOnElipsoid(e.accelerometer(1), ... % phi
                                                   e.accelerometer(2), ... % theta
                                                   [0 0 0], ...            % centre
                                                   [1 1 1], ...            % scale   
                                                   [0 0 0]);               % rotation
                samples = 1;
                
                % Add random noise as acceleration
                accelerometer = accelerometer + randn(1, 3).*0.05;
                if(mod(floor(now*10^6), 5) == 0), 
                    accelerometer = accelerometer + randn(1, 3).*0.5;
                end;
                return;
            end
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_ACCELEROMETER;
            
            e.sendPackage([]); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getAccelerometer ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 4), 
                e.showError(['getAccelerometer ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            accelerometer = v(1:3)./1000; % Devided by 1000, because received value is in mili G
            samples = v(4); % Return number of samples taken for this measurement.
        end
        
        % Get Magnetometer
        function [magnetometer, samples] = getMagnetometer(e)
            % Returns magnetic field
            
            % Initialize output value.
            magnetometer = [-1, -1, -1];
            
            % Predict measurement value if 'Demo' mode is enabled.
            if e.comm == e.COMM_DEMO
                e.magnetometer = e.magnetometer + rand(1, 2).*[0.2, 0.3];
                magnetometer = GetPointOnElipsoid(e.magnetometer(1), ... % phi
                                                  e.magnetometer(2), ... % theta
                                                  [-400 600 -100], ...   % centre
                                                  [250 200 300], ...     % scale   
                                                  [5 10 15]);            % rotation
                samples = 1;
                return;
            end

            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % Set package atributes.
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_MAGNETOMETER;
            
            e.sendPackage([]);          % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse();     % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getMagnetometer ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 4), 
                e.showError(['getMagnetometer ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            magnetometer = v(1:3);
            samples = v(4); % Return number of samples taken for this measurement.
        end
        
        % Get Light
        function [light, samples] = getLight(e)
            % Returns light level [0-1023]
            
            light = -1;
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_LIGHT;
            
            e.sendPackage([]); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getTemperature ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 2), 
                e.showError(['getTemperature ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            light = v(1);
            samples = v(2);
        end
        
        % Get All Sensors
        function [temp, accel, mag_field, light, samples] = getSensors(e, sampling_interval)
            % Returns all sensor readings.
            
            temp = nan;
            accel = nan(1, 3);
            mag_field = nan(1, 3);
            light = nan;
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end;
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_SENSORS;
            
            if(nargin == 0)
                %Read once
                e.sendPackage([]); % Send package without parameters
                e.callbackEnable = false;
                c = e.waitOnResponse(); % Wait on response
                e.callbackEnable = true;
                [h, v] = e.parsePackage(c); % Parse package

                % Check received package
                if (h.commandID ~= e.header.commandID), 
                    e.showError(['getSensors ERROR: Wrong command ID!  Content -> ' c]);
                    return;
                end

                if (length(v) ~= 9), 
                    e.showError(['getSensors ERROR: Wrong number of values!  Content -> ' c]);
                    return;
                end

                % Finally, read the received value
                temp = v(1)/1000;
                accel = v(2:4)./1000;
                mag_field = v(5:7);
                light = v(8);
                samples = v(9);
            else
                %Start continuous sampling with sampling interval
                %"sampling_interval [ms]".
                if(sampling_interval > 0)
                    e.asyncSensors = true;
                else
                    e.asyncSensors = false;
                    sampling_interval = -1;
                end
                
                e.sendPackage(floor(sampling_interval)); 
            end
        end
        
        % Get Button
        function [button] = getButton(e)
            % Returns button state
            % 1 -> Is pressed
            % 0 -> Otherwise
            
            button = -1;
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end;
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_BUTTON;
            
            e.sendPackage([]); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getButton ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) ~= 1), 
                e.showError(['getButton ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            button = v(1);
        end
        
        % Get digital pins state
        function [pins] = getDigitalPinsValue(e, vals)
            % Returns digital pins state as a n x 2 array, representing 
            % KEY-VALUE pairs of digital pins.
            % 1 -> PIN_VALUE_HIGH
            % 0 -> PIN_VALUE_LOW
            %
            % Examples:
            % getDigitalPinsValue([13; 7; 12]); 
            % Will return KEY-VALUE pairs of digital pins D13, D7 and D12. 
            
            pins = [0, -1];
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end;
            
            % Check parameters
            if (length(vals) < 1) % Array of the input parameters must include at leat one pin number. 
                e.showError('getDigitalPinsValue ERROR: Wrong number of input values! Size of input vector must be larger than zero.');
                return;
            end
            
            if (size(vals, 1) < size(vals, 2)) % Input array must be n x 1.
                e.showError('getDigitalPinsValue ERROR: Input array must be n x 1.');
                return;
            end
            
            % Add additional parameter requested by engduino protocol
            vals = [vals, zeros(length(vals), 1)];
            vals = reshape(vals', numel(vals), 1)';
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_PINS_DIGITAL_VALUE;
            
            e.sendPackage(vals); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getDigitalPinsValue ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) < 2), 
                e.showError(['getDigitalPinsValue ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            pins = reshape(v, 2, numel(v)/2)';
        end
        
        % Get analog pins value
        function [pins] = getAnalogPinsValue(e, vals)
            % Returns analog pins state as a n x 2 array, representing 
            % KEY-VALUE pairs of analog pins. Values represents pin's AD
            % value in range [0 - 1023]. The value 1023 donates to 3.3V
            %
            % Examples:
            % getAnalogPinsValue([1; 2; 4]); 
            % Will return KEY-VALUE pairs of analog pins A1, A2 and A4. 
            
            pins = [0, -1];
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end;
            
            % Check parameters
            if (length(vals) < 1) % Array of the input parameters must include at leat one pin number. 
                e.showError('getAnalogPinsValue ERROR: Wrong number of input values! Size of input vector must be larger than zero.');
                return;
            end
            
            if (size(vals, 1) < size(vals, 2)) % Input array must be n x 1.
                e.showError('getAnalogPinsValue ERROR: Input array must be n x 1.');
                return;
            end
            
            % Add additional parameter requested by engduino protocol
            vals = [vals, zeros(length(vals), 1)];
            vals = reshape(vals', numel(vals), 1)';
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_PINS_ANALOG_VALUE;
            
            e.sendPackage(vals); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getAnalogPinsValue ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end
            
            if (length(v) < 2), 
                e.showError(['getAnalogPinsValue ERROR: Wrong number of values!  Content -> ' c]);
                return;
            end
            
            % Finally, read the received value
            pins = reshape(v, 2, numel(v)/2)';
        end
        
        % Get Status
        function status = getStatus(e, vals)
            % Returns requested status parameters
            %
            % INPUT
            % val = [KEY1, KEY2, ... , KEYn]
            %
            % OUTPUT
            % res = [KEY1, VALUE1; KEY2, VALUE2; ... ; KEYn, VALUEn]
            %
            % Examples:
            % getStatus(e.STATUS_OVERSAMPLING); % Get oversampling rate
            
            status = -1;
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end;
            
            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr = engduino.checkser(e.aser,'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_STATUS;
            
            e.sendPackage(vals); % Send package without parameters
            e.callbackEnable = false;
            c = e.waitOnResponse(); % Wait on response
            e.callbackEnable = true;
            [h, v] = e.parsePackage(c); % Parse package
            
            % Check received package
            if (h.commandID ~= e.header.commandID), 
                e.showError(['getVersion ERROR: Wrong command ID!  Content -> ' c]);
                return;
            end

            % Finally, read the received value
            status = reshape(v, 2, numel(v)/2)';
        end
        
        function res = setButtonAsync(e, onOff)
            % Enable or disable button asynchronous events.
            %
            % INPUTS
            % val = true -> Enable asynchronous mode
            % val = false -> Disable asynchronous mode
            %
            % OUTPUTS
            % res = 0 -> OK
            % res < 0 -> ERROR code
            %
            % Examples:
            % setButtonAsync(true); % Enable asynchronous mode
            
            % Don't do anything if we are in "demo" mode.
            if(e.comm == e.COMM_DEMO), 
                return; 
            end; 
            
            % Check parameters
            if(onOff > 0)
                onOff = 3;
                if (e.asyncButton == true)
                    res = e.RES_OK; % Already in Async mode 
                    return;
                end
                e.asyncButton = true;
                e.buttonWasPressed(); % Dummy read.
                e.buttonWasReleased(); % Dummy read.
            else
                onOff = -1;
                e.asyncButton = false;
            end

            % Check e.aser for validity if e.chks is true
            if e.chks,
                errstr=engduino.checkser(e.aser, 'validopen');
                if ~isempty(errstr), error(errstr); end
            end
            
            % set header parameters
            e.header.packageType = e.PACKAGE_TYPE_1;
            e.header.commandID = e.COM_GET_BUTTON;
            
            % send package
            e.sendPackage(onOff); 
            
            % set the function retutn status
            res = e.RES_OK; 
        end
    end
    
     % Get and set methods
    methods
        function val = get.buttonWasPressed(e)
            val = e.buttonWasPressed;
            e.buttonWasPressed = false; % Clear after read.
        end
        
        function val = get.buttonWasReleased(e)
            val = e.buttonWasReleased;
            e.buttonWasReleased = false; % Clear after read.
        end
        
        function set.leds_r(e, ledsR)
            temp = e.leds_rgb;
            temp(:, 1) = ledsR; 
            e.setLedsRgb(temp);
        end
        
        function set.leds_g(e, ledsG)
            temp = e.leds_rgb;
            temp(:, 2) = ledsG; 
            e.setLedsRgb(temp);
        end
        
        function set.leds_b(e, ledsB)
            temp = e.leds_rgb;
            temp(:, 3) = ledsB; 
            e.setLedsRgb(temp);
        end
        
        function val = get.leds_r(e)
            val = e.leds_r_;
        end
        
        function val = get.leds_g(e)
            val = e.leds_g_;
        end
        
        function val = get.leds_b(e)
            val = e.leds_b_;
        end
        
    end
    
    methods (Static, Hidden=true) % static methods
        
        function errstr = checkser(ser, chk)
            
            % errstr = e.checkser(ser,chk); Checks serial connection argument.
            % This function checks the first argument, ser, to make sure that either:
            % 1) it is a valid serial connection (if the second argument is 'valid')
            % 3) it is open (if the second argument is 'open')
            % If the check is successful then the returned argument is empty,
            % otherwise it is a string specifying the type of error.
            
            % initialize error string
            errstr=[];
            
            % check serial connection
            switch lower(chk),
                
                case 'valid',
                    
                    % make sure is valid
                    if ~isvalid(ser),
                        disp('Serial connection invalid, please recreate the object to reconnect to a serial port.');
                        errstr='Serial connection invalid';
                        return
                    end
                    
                case 'open',
                    
                    % check openness
                    if ~strcmpi(get(ser,'Status'),'open'),
                        disp('Serial connection not opened, please recreate the object to reconnect to a serial port.');
                        errstr='Serial connection not opened';
                        return
                    end
                    
                 case 'validopen',
                     
                    % Check if serial object exsist
                    if isempty(ser),
                        disp('Serial object not initialised.');
                        errstr = 'Serial connection invalid';
                        return
                    end
                                        
                     % make sure is valid
                    if ~isvalid(ser),
                        disp('Serial connection invalid, please recreate the object to reconnect to a serial port.');
                        errstr = 'Serial connection invalid';
                        return
                    end
                    
                    % check openness
                    if ~strcmpi(get(ser, 'Status'), 'open'),
                        disp('Serial connection not opened, please recreate the object to reconnect to a serial port.');
                        errstr = 'Serial connection not opened';
                        return
                    end
                    
                otherwise
                    
                    % complain
                    error('second argument must be either ''valid'', ''open'' or ''validopen''');
                    
            end
            
        end % chackser
        
    end % static methods
    
end % class def