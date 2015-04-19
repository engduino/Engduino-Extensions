function [h] = DrawElipsoid(v, nStep, is, alpha, edgeColor)
   % Get initial size
   % is = initial Size
   [x, y, z] = meshgrid(linspace(-is, is, nStep), linspace(-is, is, nStep), linspace(-is, is, nStep));

   SolidObj = v(1)*x.*x+v(2)* y.*y+v(3)*z.*z+ 2*v(4)*y.*z + 2*v(5)*x.*z + 2*v(6)*x.*y ...
            + 2*v(7)*x + 2*v(8)*y + 2*v(9)*z + v(10)* ones(size(x));

   fv = isosurface(x, y, z, SolidObj, 0.0);
   
   if isempty(fv.vertices)
       h = 0;
       return;
   end
   
   % draw elipsoid
   minX=min(fv.vertices(:,1));  maxX=max(fv.vertices(:,1));
   minY=min(fv.vertices(:,2));  maxY=max(fv.vertices(:,2));
   minZ=min(fv.vertices(:,3));  maxZ=max(fv.vertices(:,3));
   
   minX = minX - abs((0.5*minX));
   minY = minY - abs((0.5*minY));
   minZ = minZ - abs((0.5*minZ));
   
   maxX = maxX + abs((0.5*maxX));
   maxY = maxY + abs((0.5*maxY));
   maxZ = maxZ + abs((0.5*maxZ));

   [x, y, z] = meshgrid(linspace(minX, maxX, nStep), linspace(minY, maxY, nStep), linspace(minZ, maxZ, nStep));

   SolidObj = v(1)*x.*x+v(2)* y.*y+v(3)*z.*z+ 2*v(4)*y.*z + 2*v(5)*x.*z + 2*v(6)*x.*y ...
            + 2*v(7)*x + 2*v(8)*y + 2*v(9)*z + v(10)* ones(size(x));

   fv = isosurface(x, y, z, SolidObj, 0.0);
   h = patch(fv);
   isonormals(x, y, z, SolidObj, h);
   
   set(h, 'FaceColor', 'y', 'facealpha', alpha, 'EdgeColor', edgeColor);
   %daspect([1 1 1]);
   %view(3);
   camlight;
   lighting phong;
end

