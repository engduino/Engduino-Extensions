function [fget, fset] = Box(varargin)
    obj = [];
    
    function val = get()
        val = obj;
    end
    function set(val)
        obj = val;
    end

    fget = @() get();
    fset = @(val) set(val);
end