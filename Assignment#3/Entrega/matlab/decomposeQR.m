function [ K, R, C ] = decomposeQR(P)

S = P(1:3,1:3);
[K_invertido,R_invertido] = qr(inv(S));
K = inv(K_invertido);
R = inv(R_invertido);

[~,~,V] = svd(P);
C = V(:,end); %translation

% C = center
% R = rotation
% K = intrisic camera matrix

end