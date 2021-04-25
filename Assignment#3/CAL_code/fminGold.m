function f = fminGold(p, xy, XYZ, w)

%reassemble P
P = [p(1:4);p(5:8);p(9:12)];

%compute squared geometric error & cost function value
aux = P*XYZ;
aux = aux./aux(3,:);
f = mean((xy(1,:)-aux(1,:)).^2+ (xy(2,:)-aux(2,:)).^2);

end