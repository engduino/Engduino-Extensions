%> @file engduino3.m
%> @brief Interface class for the Engduino3.
%
%> Provides methods for accessing the sensors and LEDs on the board.

classdef engduino3 < hgsetget

    properties
        %> If this is set to true, sensors will be sampled on a frequency
        %>determined by the sampling_interval property. The user-defined
        %>function in the sampling_callback will be called for every sample.
        continuous_sampling = false
        %> Interval, in ms, for sensor sampling.
        sampling_interval = 1000
        %> Function to be called for every sample, must take arguments (temp, accel, mag_field, light).
        sampling_callback = @(temp, accel, mag_field, light) disp(sprintf( ...
            'Sensors:\n     temp: %d\n     accel: %d %d %d\n     mag_field: %d %d %d\n     light: %d\n',...
            temp, accel(:), mag_field(:), light));
        
        %> Vector that controlls the red value of the LEDs. Valid values are [0:7].
        led_r = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
        %> Vector that controlls the red value of the LEDs. Valid values are [0:7].
        led_g = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
        %> Vector that controlls the red value of the LEDs. Valid values are [0:7].
        led_b = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
    end

    properties (SetAccess = protected)
        %> Serial port used to talk to the board.
        serial_port
    end
    
    properties (Hidden = true, SetAccess = protected, GetAccess = protected)
        %> Internal.
        led_r_ = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
        %> Internal.
        led_g_ = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
        %> Internal.
        led_b_ = ones(1, engduino3.LED_COUNT) .* engduino3.LED_DEFAULT_BRIGHTNESS;
    end
    
    properties (Constant = true, Hidden = true)
        BOARD_VERSION = 30
        PROTOCOL_VERSION = 1
    
        % Leds.
        LED_COUNT = 16
        LED_DEFAULT_BRIGHTNESS = 1

        % Commands
        COM_SET_LED	=           10
        COM_GET_VERSION =       100
        COM_GET_SENSORS =       110
        COM_GET_TEMPERATURE =   111
        COM_GET_ACCELEROMETER = 112
        COM_GET_MAGNETOMETER =  113
        COM_GET_LIGHT =         114
        COM_GET_BUTTON =        120
        
        % Colors.
        COLOR_RED =     0
        COLOR_GREEN =   1
        COLOR_BLUE =    2
        COLOR_YELLOW =  3
        COLOR_MAGENTA = 4
        COLOR_CYAN =     5
        COLOR_WHITE =   6
        COLOR_OFF =     7
    end

    properties (Hidden = true, SetAccess = protected)
        %> engduino_protocol object used to talk to the board.
        protocol
    end

    methods
        %> @brief Class constructor.
        %
        %> @param varargin can be one of (), (serial_object/port_name),
        %>(serial_object/port_name, baud_rate). The default constructor
        %>(i.e. engduino3()) will try to find a serial.
        %
        %> @return instance of engduino3.
        function self = engduino3(varargin)
            devices = {'serial', 'bluetooth'};
            valid_baud = [9600, 19200, 38400, 57600, 115200];
            err_help_msg = [ ...
            'Connection unsuccessful, please make sure that the board is powered on, '...
            'running a sketch provided with the package, and detected by '...
            'the operating system as a serial port. '...
            'Then restart Matlab, it only scans for hardware devices on startup.'...
            'You might also try to unplug and re-plug the USB cable.'];
            
            ports = {};
            baud = valid_baud(1);
            err = '';
            switch numel(varargin)
                case 0  % auto-connect
                    for i = 1:numel(devices)
                        try % try/catch because BT not supported on Linux(for example).
                            instr = instrhwinfo(devices{i});
                            ports = {ports{:} instr.AvailableSerialPorts{:} ...
                                     instr.SerialPorts{:}};
                        catch ex
                            err = ['Automatic port detection not supported, '...
                                   'specify the serial port as a constructor argument.'];
                        end
                    end
                case 1
                    arg = varargin{1};
                    if (isa(arg, 'serial'))
                        ports = {ports{:} arg.port};
                    else
                        ports = {ports{:} arg};
                    end
                    
                case 2
                    ports = {ports{:} varargin{1}}; 
                    baud = varargin{2};
                    if (~ismember(baud, valid_baud)),
                        error(strcat('Invalid baud rate, must be one of ', ...
                              mat2str(valid_baud), ' bit/s'));
                    end
            end        

            connected = false;
            % Try connect on all provided ports, throw at the end if none
            % succeeds.;
            for i = 1:numel(ports)
                try
                    serial_obj = serial(ports{i});
                    serial_obj.baudRate = baud;

                    self.protocol = engduino_protocol(serial_obj);
                    self.set_continuous_sampling(-1); % Might have been left on by previous object.
                    self.protocol.flush();

                    if (self.get_version() == self.BOARD_VERSION)
                        self.update_leds();
                        self.serial_port = serial_obj.port;
                        connected = true;
                        break;
                    else
                        error(['Protocol error on port ' serial_obj.port '.']);
                    end
                catch ex
                    err = sprintf('%s\n%s', err, ex.message);
                end
            end
            if (~ connected)            
                ex = MException('Matlab:Exception', ...
                                sprintf('%s\n\n%s', err, err_help_msg));
                delete(self)
                throw(ex);
            end
        end
        
        %> @brief Class destructor.
        function delete(self)
            try
                self.continuous_sampling = false;
                self.led_r(:) = 0;
                self.led_g(:) = 0;
                self.led_b(:) = 0;
                delete(self.protocol);
            catch
            end
        end
        
        %> @brief Get the version of the board.
        %
        %> @retval val the version
        function val = get_version(self)
            val = self.sample_sensor(self.COM_GET_VERSION, '%d');
            val = val{1};
        end
        
        %> @brief Get the value of the temperature sensor.
        %
        %> @retval val the temperature
        function val = get_temperature(self)
            val = self.sample_sensor(self.COM_GET_TEMPERATURE, '%d');
            val = val{1};
        end
        
        %> @brief Get the value of the light sensor.
        %
        %> @retval val the light value
        function val = get_light(self)
            val = self.sample_sensor(self.COM_GET_LIGHT, '%d');
            val = val{1};
        end
        
        %> @brief Get the value of the accelerometer.
        %
        %> @retval val the acceleration vector
        function val = get_acceleration(self)
            val = self.sample_sensor(self.COM_GET_ACCELEROMETER, '%d', '%d', '%d');
            val = cell2mat(val);
        end
        
        %> @brief Get the value of the magnetometer.
        %
        %> @retval val the magnetic field vector
        function val = get_magnetic_field(self)
            val = self.sample_sensor(self.COM_GET_MAGNETOMETER, '%d', '%d', '%d');
            val = cell2mat(val);
        end
        
        %> @brief Get the value of the button.
        %
        %> @retval val the button, true for pressed
        function val = get_button(self)
            val = self.sample_sensor(self.COM_GET_BUTTON, '%d');
            val = val{1};
        end
        
        %> @brief Set the colour and brightnes for all LEDs. Valid values
        %>are in the range [0:15].
        %
        %> @param r a 1-by-16 vector representing LED red values.
        %> @param g a 1-by-16 vector representing LED green values.
        %> @param b a 1-by-16 vector representing LED blue values.
        function set_leds(self, r, g, b)
            valid_vec = @(v, valid_f) sum(~ ismember(v, [0:15])) == 0 ...
                                      && isequal(size(v), [1 self.LED_COUNT]);
            p = inputParser;
            addRequired(p, 'r', valid_vec);
            addRequired(p, 'g', valid_vec);
            addRequired(p, 'b', valid_vec);
            parse(p, r, g, b);

            args = {};
            for i = 1:2:(6 * self.LED_COUNT)
                args{i} = '%d';
            end
            for i = 1:self.LED_COUNT
                args{6 * (i - 1) + 2} = r(i);
                args{6 * (i - 1) + 4} = g(i);
                args{6 * (i - 1) + 6} = b(i);
            end
            
            self.protocol.send('%d', self.PROTOCOL_VERSION, ...
                               '%d', self.COM_SET_LED, args{:});
                           
            self.led_r_ = r;
            self.led_g_ = g;
            self.led_b_ = b;
        end
        
        %> @brief Set method of continuous_sampling
        %
        %> @param val the value to set
        function set.continuous_sampling(self, val)
            function process_sample(values)
                for i=1:numel(values)
                    values{i} = str2num(values{i});
                end

                temp = values{3};
                accel = cell2mat({values{4:6}});
                mag = cell2mat({values{7:9}});
                light = values{10};
                self.sampling_callback(temp, accel, mag, light);
            end

            self.continuous_sampling = val;
            if (val)
                self.set_continuous_sampling(self.sampling_interval);
                self.protocol.read_callback = @process_sample;
            else
                self.set_continuous_sampling(-1);
                self.protocol.read_callback = [];
            end
        end
        
        %> @brief Set method of sampling_interval.
        %
        %> @param val the value to set
        function set.sampling_interval(self, val)
            p = inputParser;
            addRequired(p, 'val', @(x) isnumeric(x) && isscalar(x) && x > 1);
            parse(p, val);

            val = ceil(val);
            self.sampling_interval = val;
            self.continuous_sampling = self.continuous_sampling;
        end
        
        %> @brief Get method of led_r.
        %
        %> @retval val the red value vector
        function val = get.led_r(self)
            val = self.led_r_;
        end
        
        %> @brief Set method of led_r.
        %
        %> @param val the value to set
        function set.led_r(self, val)
            self.set_leds(val, self.led_g, self.led_b);
        end
        
        %> @brief Get method of led_g.
        %
        %> @retval val the red value vector
        function val = get.led_g(self)
            val = self.led_g_;
        end
        
        %> @brief Set method of led_g.
        %
        %> @param val the value to set
        function set.led_g(self, val)
            self.set_leds(self.led_r, val, self.led_b);
        end
        
        %> @brief Get method of led_b.
        %
        %> @retval val the red value vector
        function val = get.led_b(self)
            val = self.led_b_;
        end
        
        %> @brief Set method of led_b.
        %
        %> @param val the value to set
        function set.led_b(self, val)
            self.set_leds(self.led_r, self.led_g, val);
        end

    end

    methods (Hidden = true)
        %> @brief Internal, samples the specified sensor once.
        %
        %> @param sensor_id the id(command value) of the sensor to be
        %>sampled
        %> @param varargin formats(valid printf format specifiers) for the
        %>expected return value from the sensor
        %
        %> @retval values the sampled values
        function values = sample_sensor(self, sensor_id, varargin)
            if (self.continuous_sampling)
                error('Get methods are disabled while continunous_sampling is set')
            end

            self.protocol.send('%d', self.PROTOCOL_VERSION, '%d', sensor_id);
            values = self.protocol.receive('%d', '%d', varargin{:});

            assert(values{1} == self.PROTOCOL_VERSION);
            assert(values{2} == sensor_id);

            values = values(3:end);
        end
        
        %> @brief Internal, sets the sampling interval on the board.
        %
        %> @param interval the interval, in ms.
        function set_continuous_sampling(self, interval)
            self.protocol.send('%d', self.PROTOCOL_VERSION, '%d', self.COM_GET_SENSORS, ...
                               '%d', interval);
        end
        
        %> @brief Internal, updates the LEDs to the values of the
        %>properties led_r, led_g, led_b.
        function update_leds(self)
            self.set_leds(self.led_r_, self.led_g_, self.led_b_);
        end
    end
end
    