function [point] = GetPointOnElipsoid(phi, theta, c, r, rot)
    
    x = sin(phi).*cos(theta);
    y = sin(phi).*sin(theta);
    z = cos(phi); 
    
    scale = 1;
    x = ((r(1) * x)*scale);
    y = ((r(2) * y)*scale);
    z = ((r(3) * z)*scale);
        
    x = x + x*randn()*0.01;
    y = y + y*randn()*0.01;
    y = y + z*randn()*0.01;

    point = [x, y, z]';
    
    % Rotate
    Rx = rotx(rot(1));
    Ry = roty(rot(2));
    Rz = rotz(rot(3));
    point = (Rx*Ry*Rz*point)';
    
    % Translate
    point = point + repmat(c, size(point, 1), 1);
end

