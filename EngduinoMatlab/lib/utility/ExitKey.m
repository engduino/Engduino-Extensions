function [e] = ExitKey()
    % This funcion returns 0 when user press:
    % ESC, Q, q,
    % data -> plot buffer
    % engduinoObject -> Engduino object
    % buttonExit -> True or False. (Set on true for termination on button
    % press).
    e = 1;

    
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
        close all hidden;
    end
end

