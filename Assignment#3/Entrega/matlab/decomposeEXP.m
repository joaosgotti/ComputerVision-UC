function [ K, R, C ] = decomposeEXP(M)
% f = distância focal
A = M(:,1:3);
b = M(:,end);
C = -inv(A)*b;

a1 = A(1,:);
a2 = A(2,:);
a3 = A(3,:);


epslon = 1;  %% ?? %%
epslon_U = 1; %% ?? %%
epslon_V = 1; %% ?? %%

rho = epslon/norm(a3);

%elementos da matriz de rotacao
r1 = cross(a2,a3)/norm(cross(a2,a3));
r3 = rho*a3;
r2 = cross(r3,r1);

u0 = pow2(rho)*dot(a1,a3);
v0 = pow2(rho)*dot(a2,a3);

e = -(epslon_U * epslon_V); %% ?? %%
d = norm(cross(a1,a3))*norm(cross(a2,a3));
cos_theta = e*  (dot(cross(a1,a3),cross(a2,a3)))/d;

alpha = epslon_U*pow2(rho)*norm(cross(a1,a3))*sin(acos(cos_theta));
beta = epslon_V*pow2(rho)*norm(cross(a1,a3))*sin(acos(cos_theta));

K = [-alpha, cos_theta, u0
     0,      beta,      v0
     0,      0,         1];
 
 R = [r1
      r2
      r3];
  

end