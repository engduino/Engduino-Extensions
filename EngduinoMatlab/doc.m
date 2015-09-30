function doc(varargin)

% Define a list of functions associated with the toolbox.
toolboxFiles = {'analogRead', 'analogWrite'};
% toolboxFiles = load('myToolboxFileList.mat');

% If the input to DOC is a toolbox function, then open its HTML page
% directly.
if nargin == 1 && ismember(varargin{1}, toolboxFiles)
        % Toolbox installation directory.
        toolboxDir = fullfile(strrep(userpath, ';', ''), 'Toolboxes', 'EngduinoMatlab');
        % Toolbox help directory.
        toolboxHelpDir = fullfile(toolboxDir, 'help', 'html','api');
        % Open the corresponding HTML page.
        web(['file:///', toolboxHelpDir, filesep, varargin{1}, '.html'])
        
% Otherwise, pass the arguments to the usual DOC function.    
else
    % We need to invoke the correct DOC function here, so a change of
    % directory is required as we now have two DOC functions on the path.
    % Safeguard against errors by using an onCleanup object which changes
    % back to the original directory if an unexpected error occurs.
    d = pwd;
    oc = onCleanup( @() cd(d) );
    % Directory where the usual DOC function is.
    cd(fullfile(matlabroot, 'toolbox', 'matlab', 'helptools'))
    f = @doc;
    cd(d)
    % Invoke the DOC function.
    feval(f, varargin{:});
end % if

end % function