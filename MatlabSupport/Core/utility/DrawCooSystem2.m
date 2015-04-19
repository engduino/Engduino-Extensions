function [h] = DrawCooSystem2(center, rotMatrx, scale, lineWidth, dispText)

    if ~isreal(rotMatrx)
        h(1) = 0;
        return;
    end

    c = center;
    R = rotMatrx/norm(rotMatrx);
    s = scale;
    width = lineWidth;

    if(length(s) < 3)
        s = [1 1 1];
    end

    s = repmat(s',1,3);
    coo = [1 0 0; 0 1 0; 0 0 1];
    coo = coo.*s';
    coo = R*coo;
    coo = coo+repmat(c, 3, 1);

    hold on;
    X = [coo(1, 1); c(1)];
    Y = [coo(1, 2); c(2)];
    Z = [coo(1, 3); c(3)];
    h(1) = plot3(X, Y, Z, 'r', 'linewidth', width);

    X = [coo(2, 1); c(1)];
    Y = [coo(2, 2); c(2)];
    Z = [coo(2, 3); c(3)];
    h(2) = plot3(X, Y, Z, 'g', 'linewidth', width);

    X = [coo(3, 1); c(1)];
    Y = [coo(3, 2); c(2)];
    Z = [coo(3, 3); c(3)];
    h(3) = plot3(X, Y, Z, 'b', 'linewidth', width);

    if(dispText == true)
        %text(coo(:,1), coo(:,2), coo(:,3), ['+X';'+Y';'+Z']);
    end

    axis equal

end

