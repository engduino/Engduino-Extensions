function plotTemperature_smooth

addpath(genpath('../core'))

disp('Upload Engduino Protocol....')
uploadToEngduino_platformio;

pause(1)
e = engduino();
pause(2)
alpha=0.1;
y=0;

for (i=1:200)
    %average of 10 temperatures
    for (j=1:10)
        tem = e.getTemperature();
        y = (y*(i-1)+tem)/i; 
    end
    x(i)=y;
    figure(1)
    plot([1:i], x(1:i), '.-')
    drawnow
    pause(0.1);
end

delete(e)

end