function [K, R, t, error] = runDLT(xy, XYZ, Dtype)

[xy_normalized, XYZ_normalized, T, U] =normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
M = T\P_normalized*U;

%factorize camera matrix in to K, R and C
if(Dtype == 'QR')
    [ K, R, C ] = decomposeQR(M);
elseif(Dtype=='EXP')
    [ K, R, C ] = decomposeEXP(M);
else
    error('Incompatible decomposition method'); 
end

%compute reprojection error

end