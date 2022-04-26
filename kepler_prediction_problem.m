function [rf,vf] = kepler_prediction_problem(mu_e,t1,a,e,i,o,w,v)
%This code will take inputs of the gravitation parameter, time of flight and orbital elements
%The output will be the position and velocity vectors at the final position

%Establish r and v in the PQW plane, rotate them to XYZ
p = a*(1-e^2);
r = p/(1+ e*cosd(v));
rpq = [r*cosd(v); r*sind(v); 0];
vpq = sqrt(mu_e/p)*[-sind(v); (e+cosd(v)); 0];
Ro = [cosd(o) sind(o) 0;-sind(o) cosd(o) 0; 0 0 1];
Ri = [1 0 0; 0 cosd(i) sind(i);0 -sind(i) cosd(i)];
Rw = [cosd(w) sind(w) 0;-sind(w) cosd(w) 0;0 0 1];
R = (Rw*Ri*Ro);
Rt = R^-1;
rc = Rt*rpq;
vc = Rt*vpq;
%Establish chi and sai, create if statements to find C and S
chi_n = sqrt(mu_e)*t1/a;
sai = (chi_n^2)/a;
if sai > 1E-6
    C = (1-cos(sqrt(sai)))/sai;
    S = (sqrt(sai)-sin(sqrt(sai)))/sqrt(sai^3);
elseif sai < -1E-6
    C = (1-cosh(sqrt(-sai)))/sai;
    S = (sinh(sqrt(-sai))-sqrt(-sai))/sqrt((-sai)^3);
else
    C = 1/2;
    S = 1/6;
end
t = (S*chi_n^3 + (dot(rc,vc)/sqrt(mu_e))*C*chi_n^2 + norm(rc)*chi_n*(1-(sai*S)))/sqrt(mu_e);
%Iterative steps
while abs(t-t1) > 1
    z = C*chi_n^2 + (dot(rc,vc)/sqrt(mu_e))*chi_n*(1-(sai*S)) + norm(rc)*(1-(sai*C));
    dchi = sqrt(mu_e)/z;
    t = (S*chi_n^3 + (dot(rc,vc)/sqrt(mu_e))*C*chi_n^2 + norm(rc)*chi_n*(1-(sai*S)))/sqrt(mu_e);
    chi_n = chi_n + (t1-t)*dchi;
end
%Use lagrange coeffs to find rf and vf
f = 1 - (chi_n^2)*C/norm(rc);
fd = (sqrt(mu_e)/(norm(rc)*z))*chi_n*(sai*S -1);
g = t - (chi_n^3)*S/sqrt(mu_e);
gd = 1 - (C/z)*chi_n^2;
rf = f*rc + g*vc;
vf = fd*rc + gd*vc;
end
