function [v0,vf] = lambert(ro,rf,T,DM,mu)
dV = acos(dot(ro,rf)/(norm(ro)*norm(rf)));
A = DM*sqrt(norm(ro)*norm(rf)*(1+cos(dV)));
if dV==0 || A==0
    disp('Error')
else 
    psi = 0;
    C2 = 1/2;
    C3 = 1/6;
    psiUP = 4*pi*pi;
    psiLOW = -4*pi;
    dt = 0;
while abs(T-dt) > 1E-6
    y = norm(ro)+norm(rf)+ (A*(psi*C3 -1)/sqrt(C2));
    if A> 0 && y<0
        psiLOW = psiLOW+1;
    end
    X = sqrt(y/C2);
    dt = (C3*(X^3) + A*sqrt(y))/sqrt(mu);
    if dt < T
        psiLOW = psi;
    else
        psiUP = psi;
    end
    psi = (psiUP+psiLOW)/2;
    if psi > 1E-6
        C2 = (1-cos(sqrt(psi)))/psi;
        C3 = (sqrt(psi) -sin(sqrt(psi)))/sqrt(psi^3);
    elseif psi < -1E-6
        C2 = (1-cosh(sqrt(-psi)))/psi;
        C3 = (sinh(sqrt(-psi))-sqrt(-psi))/sqrt(-(psi)^3);
    else
        C2 = 1/2;
        C3 = 1/6;
    end
end
f = 1-(y/norm(ro));
g = A*sqrt(y/mu);
gd = 1 -(y/norm(rf));
v0 = (rf- f.*ro)/g; %v0
vf = (gd.*rf - ro)/g; %vf
end
end