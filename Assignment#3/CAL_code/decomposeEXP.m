function [ K, R, C ] = decomposeEXP(M)
% f = distância focal
alfa = Kx * f;

A= M(1:3,1:3);
b=M(:,end);
C=-A\b;




%decompose P into K, R and t

end