function [Offsets, ScaleFactors, v] = GetOffsetsAndScaleFactors(mag, normaVal)
    % https://sites.google.com/site/sailboatinstruments1/step-1
    %% do the fitting
    dx = mag(:,1);
    dy = mag(:,2); 
    dz = mag(:,3);
    n = size(dx,1);

    if n < 5
        Offsets = 0;
        ScaleFactors = 0;
        v = 0;
        return;
    end

    D = [dx.*dx, dy.*dy,  dz.*dz, 2.*dy.*dz, 2.*dx.*dz, 2.*dx.*dy, 2.*dx, 2.*dy, 2.*dz, ones(n,1)]';
    S = D*D';
    v = ElipsoidFit(S);

    %% calculate offsets and scale factors
    Q = [v(1) v(6) v(5); v(6) v(2) v(4); v(5) v(4) v(3)];
    U = [v(7) v(8) v(9)];

    B = Q\U';
    B = -B;

    btqb = B'*Q*B;
    hmb = sqrt(btqb - v(10)); % B'QB - J
    SQ = sqrtm(Q);
    Ainv = (normaVal/hmb)*SQ;

    Offsets = B;
    ScaleFactors = Ainv;
end

