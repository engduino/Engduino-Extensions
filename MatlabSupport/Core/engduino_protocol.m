%> @file engduino_protocol.m
%> @brief Implements the low-level engduino protocol.
%
%> The engduino serial protocol uses { as a message start and } as message
%stop. The message contains values separated by ;.

classdef engduino_protocol < hgsetget
    
    properties
        %> Set this to a function that will be called for every received message.
        read_callback = ''
        
        %> Setting this to true will disp() all sent and received messages.
        debug = false
    end
    
    properties (Constant = true, Hidden = true)
        %> Protocol start character.
        packet_start = '{'
        %> Protocol separator character.
        packet_separator = ';'
        %> Protocol stop character.
        packet_end = '}'
        %> Protocol serial parameters.
        serial_properites = containers.Map( ...
            {'terminator'                 'parity', 'DataBits', 'BytesAvailableFcnMode', 'Timeout'}, ...
            {engduino_protocol.packet_end 'none'    8,          'terminator', 1})
    end
    
    methods
        %> @brief Class constructor.
        %
        %> @param serial_obj serial object used to communicate with the board.
        %> @return instance of engduino_protocol.
        function self = engduino_protocol(serial_obj)
            if ((~ isa(serial_obj, 'serial')) || ~ isvalid(serial_obj))
                error('Argument must be a valid serial object');
            end
            
            % Close any existing serials on this port.
            serials = instrfindall('Port', serial_obj.port);
            for i=1:length(serials)
                fclose(serials(i));
            end

            keys = self.serial_properites.keys;
            for k=1:numel(keys)
                set(serial_obj, keys{k}, self.serial_properites(keys{k}));
            end
            
            fopen(serial_obj);
            self.serial_obj = serial_obj;
            self.flush();
        end
        
        %> @brief Class destructor.
        %
        %> Tries to close the serial object.
        function delete(self)
            try
                self.read_callback = '';
                fclose(self.serial_obj);
            catch
            end
        end
        
        %> @brief Formats and sends a variable number of arguments.
        %> For example, send('%d', 10, '%s', 'test') will send '{1;test}'.
        %> Formats must pe valid printf format specifiers.
        %
        %> @param varargin pairs of format, value
        function send(self, varargin)
            formats = varargin(1:2:numel(varargin));
            values = varargin(2:2:numel(varargin));
            
            str_values = {};
            for arg_i = 1:numel(formats)
                str_values{arg_i} = sprintf(formats{arg_i}, values{arg_i});
            end
            
            msg = strcat(self.packet_start, ...
                         strjoin(str_values, self.packet_separator), ...
                         self.packet_end);
            if (self.debug)
                disp(msg);
            end
            
            fwrite(self.serial_obj, msg);
        end
        
        %> @brief Reads and formats a variable number of values.
        %> For example, receive('%d', '%s') will read '{1;test}'.
        %> Formats must pe valid printf format specifiers.
        %
        %> @param varargin formats for each value to be read
        %> @retval values the read values
        function values = receive(self, varargin)
            format = strcat(self.packet_start, ...
                            strjoin(varargin, self.packet_separator), ...
                            self.packet_end);
                      
            out = fscanf(self.serial_obj, '%s');
            out = sscanf(out, format);
            
            if (self.debug)
                disp(format)
                disp(out)
            end
            
            values = {};
            for arg_i = 1:numel(varargin)
                values{arg_i} = out(arg_i);
            end
        end
            
        %> @brief Clears the read buffer of the serial.
        function flush(self)
            nr_bytes = self.serial_obj.BytesAvailable;
            if (nr_bytes > 0)
                fread(self.serial_obj, self.serial_obj.BytesAvailable);
            end
        end
        
        %> @brief Set method of read_callback.
        function val = get.read_callback(self)
            val = self.read_callback;
        end
        
        %> @brief Get method of read_callback.
        %
        %> @param val the value to set
        function set.read_callback(self, val)
            %> Internal
            function read_packet(varargin)
                str = fscanf(self.serial_obj, '%s');
                str = str(2:end-1);
                values = strsplit(str, ';');
                self.read_callback(values)
            end
        
            self.read_callback = val;
            if (~ isempty(val))
                self.serial_obj.BytesAvailableFcn = @read_packet;
            else
                self.serial_obj.BytesAvailableFcn = '';
            end
        end
        
    end
    
    properties (Hidden = true)
        %> Serial object used to talk to the board.
        serial_obj
    end
        
end