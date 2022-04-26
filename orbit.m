function zdot = orbit(t,r,mu);
z1 = r(4:6);
z2 = -mu*r(1:3)/(norm(r(1:3))^3);
zdot = [z1;z2];
end