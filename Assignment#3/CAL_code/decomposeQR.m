function [ K, R, C ] = decomposeQR(P)

[~,~,V] = svd(P);
C = V(:,end);
[K,R] = qr(inv(P(1:3,1:3)));

% C = center
% R = rotation
% K = intrisic camera matrix

end