function [K, R, C, error] = runGold(xy, XYZ, Dtype)

%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];

[pn] = fminsearch(@fminGold, pn, [], xy_normalized, XYZ_normalized, i/5);

pn = [pn(1:4);pn(5:8);pn(9:12)];


%denormalize camera matrix
P = T\pn*U;
%factorize camera matrix in to K, R and t

if(strcmp(Dtype,'QR'))
    [ K, R, C ] = decomposeQR(P);
elseif(strcmp(Dtype,'EXP'))
    [ K, R, C ] = decomposeEXP(P);
else
    error('Incompatible decomposition method'); 
end

%compute reprojection error
new = P*[XYZ;ones(1,length(XYZ))];
new = new./new(3,:);
error = mean((xy(1,:) - new(1,:)).^2+(xy(2,:) - new(2,:)).^2,'all'); %% REDO

end