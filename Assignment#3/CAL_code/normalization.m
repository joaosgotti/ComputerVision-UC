function [xyn, XYZn, T, U] = normalization(xy, XYZ)
    %% matriz T %%
    n = size(xy,2);
    x = xy(1,:); y = xy(2,:);
    Cx = mean(x); Cy = mean(y);
    s2d = sqrt(2)*n/sum(sqrt( (x-Cx).^2 + (y-Cy).^2),'all');%sqrt*sum/n
    
    T = [1/s2d 0   Cx
         0 1/s2d  Cy
         0  0    1];
    T=inv(T);
    xyscaled=[xy;ones(1,n)];
    xyn  = T*xyscaled;
    
    %% matriz U %%
    N = size(XYZ,2);
    X = XYZ(1,:); Y = XYZ(2,:); Z = XYZ(3,:);
    CX = mean(X); CY = mean(Y); CZ = mean(Z);
   
    s3d = sqrt(3)*N/sum( sqrt(    (X-CX).^2   +   (Y-CY).^2   +   (Z-CZ).^2      ),'all' );
          
    U = [1/s3d 0  0  CX
          0 1/s3d 0  CY
          0  0 1/s3d CZ
          0  0  0  1];
    U=inv(U);
    XYZscaled=[XYZ; ones(1,N)];
    XYZn  = U*XYZscaled;

    
end