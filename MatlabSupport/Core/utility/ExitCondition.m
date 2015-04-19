function [e] = ExitCondition(data, engduinoObject, buttonExit)
    % This funcion returns 0 when user press:
    % ESC, Q, q,
    % data -> plot buffer
    % engduinoObject -> Engduino object
    % buttonExit -> True or False. (Set on true for termination on button
    % press).
    e = 1;
    callstr = 'set(gcbf,''Userdata'',double(get(gcbf,''Currentcharacter''))) ; uiresume ';
    
    if isempty(findall(0, 'Type', 'Figure'))
        if(length(data) > 1)
            e = 0;
            return;
        end
        % get or create figure handle
        h = gcf;
        set(gcf, ...
            'name',         'Press a key', ...
            'keypressfcn',  callstr, ...
            'windowstyle',  'modal',...
            'numbertitle',  'off', ...
            'position',     [0 0  1 1],...
            'userdata',     'timeout');
    else
        h = gcf;
        set(gcf, ...
            'keypressfcn',  callstr, ...
            'userdata',     'timeout');
    end
    
    if(~isempty(engduinoObject))
        if(buttonExit == true)
           engduinoObject.setButtonAsync(true);
           if(engduinoObject.buttonWasPressed() == true)
               e = 0;
               delete(h);
               return;
           end
        end
    end
    
    %hManager = uigetmodemanager(h);
    %set(hManager.WindowListenerHandles, 'Enable', 'off');
    warning('off', 'MATLAB:modes:mode:InvalidPropertySet');
    
    % read last pressed key
    ch = get(h, 'CurrentCharacter');

    % Chech for characters:
    % ESC
    % Q
    % q
    if ismember(ch, [27, 81, 113])
        % return zero if any of the acceptable key was pressed.
        e = 0;
        delete(h);
    end
end

