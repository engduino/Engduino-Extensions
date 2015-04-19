function [instr_names, instr_cons] = instruments(varargin)
% Returns names and constructors for specified instrument classes, for
% example instruments('serial', 'bluetooth').

    instr_cls = {'serial' 'bluetooth'};
    instr_names_get = {@(inst) inst.SerialPorts @(instr) instr.RemoteName};
    instr_names = {};
    instr_cons = {};
    
    if (numel(varargin) > 0)
        instr_cls_to_scan = varargin;
    else
        instr_cls_to_scan = instr_cls;
    end
    
    for i = 1 : numel(instr_cls_to_scan)
        cls = instr_cls_to_scan{i};
        if (~ ismember(lower(cls), instr_cls))
            error([cls ' is not a valid instrument class, supported ones are ' ...
                   strjoin(instr_cls, ', ')]);
        end
  
        try
            devices = instrhwinfo(cls);
            names_get = instr_names_get{i};
            names = names_get(devices);

            instr_names = {instr_names{:} names{:}};
            instr_cons = {instr_cons{:} devices.ObjectConstructorName{:}};
        catch
        end
    end
end