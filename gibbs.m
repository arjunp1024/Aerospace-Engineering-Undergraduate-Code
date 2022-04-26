function [v1,v2,v3] = gibbs(r1,r2,r3,mu)
D = cross(r2,r3)+cross(r3,r1)+cross(r1,r2);
N = norm(r1)*cross(r2,r3)+ norm(r2)*cross(r3,r1) + norm(r3)*cross(r1,r2);
p = norm(N)/norm(D);
S = (norm(r1)-norm(r2))*r3 + (norm(r3)-norm(r1))*r2 +(norm(r2)-norm(r3))*r1;
e = norm(S)/norm(D);
L = sqrt(mu/((norm(D)*norm(N))));
B1 = cross(D,r1);
B2 = cross(D,r2);
B3 = cross(D,r3);
v1 = norm(L)*B1/norm(r1) + norm(L)*S;
v2 = norm(L)*B2/norm(r2) + norm(L)*S;
v3 = norm(L)*B3/norm(r3) + norm(L)*S;
end