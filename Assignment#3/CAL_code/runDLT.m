function [K, R, t, error] = runDLT(xy, XYZ)

%normalize data points
xy_normalized = xy/abs(xy);
XYZ_normalized = XYZ/abs(XYZ);

%compute DLT
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%denormalize camera matrix

%factorize camera matrix in to K, R and t

%compute reprojection error

end