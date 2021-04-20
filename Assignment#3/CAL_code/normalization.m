function [xyn, XYZn, T, U] = normalization(xy, XYZ)
    %% matriz T %%
    n = size(xy,2);
    x = xy(1,:); y = xy(2,:);
    Cx = mean(x); Cy = mean(y);
    s2d = sqrt(2)*n/sum(sqrt( (x-Cx).^2 + (y-Cy).^2),'all')

    T = inv([s2d 0   Cx
              0 s2d  Cy
              0  0    1]);

    xyn  = T*[xy; ones(1,n)];
    
    %% matriz U %%
    N = size(XYZ,2);
    X = XYZ(1,:); Y = XYZ(2,:); Z = XYZ(3,:);
    CX = mean(x); CY = mean(y); CZ = mean(z);
   
    s3d = sqrt(3)*N/sum( sqrt( X-CX).^2 + (Y-CY).^2 + (Z-CZ).^2),'all' );
          
    U = inv([s3d 0  0  CX
              0 s3d 0  CY
              0  0 s3d CZ
              0  0  0  1]);

    XYZn  = U*[xy; ones(1,N)];

    
end