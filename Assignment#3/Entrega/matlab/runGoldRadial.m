function [K, R, C, Kd, error] = runGoldRadial(xy, XYZ, Dtype)

%normalize data points
[xy_normalized ,XYZ_normalized,T,U] = normalization(xy,XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:) 0 0];

[pn] = fminsearch(@fminGoldRadial, pn, [], xy_normalized, XYZ_normalized);

Kd = pn(13:14);

P_normalized = [pn(1:4);pn(5:8);pn(9:12)];


%denormalize camera matrix
P = T\P_normalized*U
%factorize camera matrix in to K, R and t
if(strcmp(Dtype,'QR'))
    [ K, R, C ] = decomposeQR(P);
elseif(strcmp(Dtype,'EXP'))
    [ K, R, C ] = decomposeEXP(P);
else
    error('Incompatible decomposition method'); 
end
%compute reprojection error
ptsc = P*[XYZ;ones(1,length(XYZ))];
ptsc = ptsc./ptsc(3,:);

error = mean((xy(1,:) - ptsc(1,:)).^2 + (xy(2,:) - ptsc(2,:)).^2,'all');


end