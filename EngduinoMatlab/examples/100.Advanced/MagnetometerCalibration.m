%% MagnetometerCalibration.m demo example.
%
% Description:
% This example shows calibration of Engduino's magnetometer. 
% Because the measured magnetic field is a combination of both the earth's 
% magnetic field and any magnetic field created by nearby ferromagnetic 
% objects, is very important to perform accurate calibration procedure to
% remove Hard-iron and Soft-iron distortions. 
% The main idea of calibration is to translate centre of ellipsoid to 
% origin and transform it into a sphere.  
%
% July 2014, Engduino team: support@engduino.org

%% Initialize variables

% Check if the Engduino object already exists. Otherwise initialize it.
if (~exist('e', 'var'))
    % Create Engduino object and open COM port. You do not need to select
    % an active COM port, as it should be detected automatically. However,
    % in the case of unsuccessful connection, you may initialize Engduino
    % object with passing the active COM port. E.g. e = engduino('COM8');
    % To open the 'Bluetooth' port you need to initialize the Engduino
    % object with the 'Bluetooth' keyword and your Bluetooth device name.
    % E.g. e = engduino('Bluetooth', 'HC-05'); Demo mode can be enabled by
    % initialize the Engduino object with 'demo' keyword. E.g. e =
    % engduino('demo');
    e = engduino();
end

% Set reading frequency [Hz]. Readings per second.
frequency = 15;

% Global variables.
mag = [];
i = 1;

%% Set up the figure. 
figureHandle = figure('NumberTitle', 'off',...
                      'Name', 'Engduino Magnetometer calibration', ...
                      'Visible', 'off', ...
                      'units','normalized', ...
                      'outerposition', [0 0 1 1], ... % fullscreen
                      'Visible', 'on');

% Subplots handles.
hold on;
p = zeros(1,2);
ph = zeros(1,2);
p(1) = subplot(1,2,1);
p(2) = subplot(1,2,2);

% Create Plot objects.
ph(1) = plot3(p(1), nan, nan, nan);
ph(2) = plot3(p(2), nan, nan, nan);

% Turn Grid on.
set(p(1), 'YGrid', 'on', 'XGrid', 'on', 'ZGrid', 'on');
set(p(2), 'YGrid', 'on', 'XGrid', 'on', 'ZGrid', 'on');

% Set Labels.
xlabel(p(1), 'Mx (milli Gauss)', 'FontSize', 12);
ylabel(p(1), 'My (milli Gauss)', 'FontSize', 12);
zlabel(p(1), 'Mz (milli Gauss)', 'FontSize', 12);
xlabel(p(2), 'Mx (normalized)', 'FontSize', 12);
ylabel(p(2), 'My (normalized)', 'FontSize', 12);
zlabel(p(2), 'Mz (normalized)', 'FontSize', 12);

% Set 3D view.
daspect([1 1 1]);
view(3);

 
%% Real-time plot.
% Execute loop until 'ESC' or 'q' is pressed!
disp('Press ''ESC'' or ''q'' to terminate execution...')
disp('You can terminate execution by:')
disp('- Press ''ESC''')
disp('- Press ''q''')
disp('- Press a button on the Engduino board')
disp('- Close the figure')
while ExitCondition(mag, e, true)
    % Read magnetometer measurement from Engduino's magnetometer sensor. 
    magTemp = e.getMagnetometer();
    mag = [mag; magTemp(1:3)];
 
    % Compute offsets and scale factors.
    [B, Ainv, v] = GetOffsetsAndScaleFactors(mag, 0.569);
    
    % Delete Plot handles.
    if (exist('he', 'var')  && he(1)  ~= 0), delete(he);  end
    if (exist('hcp', 'var') && hcp(1) ~= 0), delete(hcp); end
    if (exist('hc', 'var')  && hc(1)  ~= 0), delete(hc);  end
    if (exist('he2', 'var') && he2(1) ~= 0), delete(he2); end
    if (exist('hc2', 'var') && hc2(1) ~= 0), delete(hc2); end
    
    % Plot raw data.
    subplot(1,2,1)
    
    % Plot additional data if we have valid calibration factors. 
    if (v(1)~=0 && isreal(v))
        set(ph(1), 'XData', mag(:,1), 'YData', mag(:,2), 'ZData', mag(:,3), ...
               'Color', 'c', 'Marker', 'o', 'MarkerSize', 7, ... 
               'MarkerEdgeColor', [0.3 0.7 1], 'lineWidth', 2);
           
        he = DrawElipsoid(v, 50, 3000, 0.1, repmat(0.5, 1, 3));
        hcp = DrawCooSystem2([0 0 0], rotx(0), [700 700 700], 4, true);
        hc = DrawCooSystem2(B', inv(Ainv), [700 700 700], 3, true);
    end
    
    
    % Plot calibrated data.
    subplot(1,2,2)
    if (v(1)~=0 && isreal(v))
        % remove magnetometer offset
        magC = mag - repmat(B', size(mag, 1), 1);
        
        % apply scale factors
        cal = [];
        cal(:,1) = Ainv(1,1)*magC(:,1) + Ainv(1,2)*magC(:,2) + Ainv(1,3)*magC(:,3);
        cal(:,2) = Ainv(2,1)*magC(:,1) + Ainv(2,2)*magC(:,2) + Ainv(2,3)*magC(:,3);
        cal(:,3) = Ainv(3,1)*magC(:,1) + Ainv(3,2)*magC(:,2) + Ainv(3,3)*magC(:,3);
        
        % Compute offsets and scale factors on calibrated data.
        [B, Ainv, v] = GetOffsetsAndScaleFactors(cal, 0.569);
        
        % Plot additional data if we have valid calibration factors. 
        if (v(1)~=0 && isreal(v))
            set(ph(2), 'XData', cal(:,1), 'YData', cal(:,2), 'ZData', cal(:,3), ... 
                       'Color', 'c', 'Marker', 'o', 'MarkerSize', 7, ... 
                       'MarkerEdgeColor', [0.3 0.7 1], 'lineWidth', 2);
                   
            he2 = DrawElipsoid(v, 50, 2, 0.1, repmat(0.5, 1, 3));
            hc2 = DrawCooSystem2(B', inv(Ainv), [1 1 1], 3, true);
        end
    end
    
    % Set Title.
    title(p(1), ['Raw magnetometer measurements;  n = ', num2str(i)], 'FontSize', 14);
    title(p(2), ['Calibrated magnetometer measurements;  n = ', num2str(i)], 'FontSize', 14);

    % Pause for the time interval.
    pause(1/frequency);

    % Increment counter.
    i = i + 1;
end