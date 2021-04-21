function [P] = dlt(xy, XYZ)
%computes DLT, xy and XYZ should be normalized before calling this function
A=[];


for i=1:length(xy)
	A = [A;
        XYZ(:,i)', [0 0 0 0], -xy(1,i)*(XYZ(:,i)')
        0 0 0 0    XYZ(:,i)'  -xy(2,i)*(XYZ(:,i)')];
end

[~,~,V]= svd(A);


P(1,:) = V(1:4,end);
P(2,:) = V(5:8,end);
P(3,:) = V(9:12,end);





end
