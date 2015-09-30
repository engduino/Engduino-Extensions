function  r  = RollDice(e)


firstUpdate = true;
shakeThreshold = 0.4;
shakeInitiated = false;
xPreviousAccel = 0;
yPreviousAccel = 0;
zPreviousAccel = 0;
xAccel=0;
yAccel=0;
zAccel=0;
shake = false;
shakeStop = false;
i=0;



readings = e.getAccelerometer();
xPreviousAccel = readings(1);
yPreviousAccel = readings(2);
zPreviousAccel = readings(3);
firstUpdate = false;
pause(0.1);

readings = e.getAccelerometer();
xAccel = readings(1);
yAccel = readings(2);
zAccel = readings(3);

deltaX = abs(xPreviousAccel - xAccel);
deltaY = abs(yPreviousAccel - yAccel);
deltaZ = abs(zPreviousAccel - zAccel);
   
if((deltaX>shakeThreshold&&deltaY>shakeThreshold)||(deltaX>shakeThreshold&&deltaZ>shakeThreshold)||(deltaY>shakeThreshold&&deltaZ>shakeThreshold))
    shakeInitiated = true;
end

if(shakeInitiated==true)
    while(not(shakeStop))
        readings = e.getAccelerometer();
        xPreviousAccel = xAccel;
        yPreviousAccel = yAccel;
        zPreviousAccel = zAccel;

        xAccel = readings(1);
        yAccel = readings(2);
        zAccel = readings(3);

        deltaX = abs(xPreviousAccel - xAccel);
        deltaY = abs(yPreviousAccel - yAccel);
        deltaZ = abs(zPreviousAccel - zAccel);
   
        if((deltaX>shakeThreshold&&deltaY>shakeThreshold)||(deltaX>shakeThreshold&&deltaZ>shakeThreshold)||(deltaY>shakeThreshold&&deltaZ>shakeThreshold))
            shakeInitiated = true;
            i=0;
        else
            i=i+1;
        end
   
        if(i>10&&shakeInitiated)
            shakeStop = true;
        end
    end
    r = true; 
    
else
    r = false;
end
end

