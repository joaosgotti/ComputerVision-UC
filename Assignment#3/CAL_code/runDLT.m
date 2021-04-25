function [K, R, C, error] = runDLT(xy, XYZ, Dtype)

[xy_normalized, XYZ_normalized, T, U] =normalization(xy, XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix
M = T\P_normalized*U;

%factorize camera matrix in to K, R and C
if(strcmp(Dtype,'QR'))
    [ K, R, C ] = decomposeQR(M);
elseif(strcmp(Dtype,'EXP'))
    [ K, R, C ] = decomposeEXP(M);
else
    error('Incompatible decomposition method'); 
end

%compute reprojection error
ximg=xy(1,:);
yimg=xy(2,:);
m1=M(1,:);
m2=M(2,:);
m3=M(3,:);
tamanho=length(XYZ);
P=[XYZ;ones(1,tamanho)];
for i=1:tamanho
    xest(i)=(m1*P(:,i))/(m3*P(:,i));
    yest(i)=(m2*P(:,i))/(m3*P(:,i));
end
plot(ximg,yimg,'o')
hold on
plot(xest,yest,'rx')
hold on
reprojection_error=0
for i=1:tamanho
D=(sqrt((xest(i)-ximg(i))^2+(yest(i)-yimg(i))^2))^2;
reprojection_error=reprojection_error+D
end