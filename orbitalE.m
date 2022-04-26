function [OrbitalElements] = orbitalE(length,mu,vec);
%With inputs of the gravitational parameter, a vector containing position and velocity vectors, and the length of said vector
%This code will output the orbital elements as well as plot their osculations over time
n = 1;
while n < length+1
OrbitalElements(n,1) = -mu/(2*(.5*((norm(vec(n,4:6)))^2) -mu/norm(vec(n,1:3))));
ew(n,1:3) = ((((norm(vec(n,4:6))^2)- mu/norm(vec(n,1:3)))*vec(n,1:3)) - (dot(vec(n,1:3),vec(n,4:6))*vec(n,4:6)))/mu;
OrbitalElements(n,2) = norm(ew(n,1:3));

AngMome(n,1) = vec(n,2)*vec(n,6) - vec(n,3)*vec(n,5);
AngMome(n,2) = -vec(n,1)*vec(n,6) + vec(n,3)*vec(n,4);
AngMome(n,3) = vec(n,1)*vec(n,5) - vec(n,2)*vec(n,4);
AngMome(n,4) = norm(AngMome(n,1:3));

OrbitalElements(n,3) = acosd(AngMome(n,3)/AngMome(n,4));
AngNe(n,1) = -AngMome(n,2);
AngNe(n,2) = AngMome(n,1);
AngNe(n,3) = 0;

OrbitalElements(n,4) = acosd(AngNe(n,1)/(norm(AngNe(n,1:2))));
OrbitalElements(n,5) = acosd((dot(AngNe(n,1:3),ew(n,1:3)))/(norm(AngNe(n,1:2))*OrbitalElements(n,2)));
if ew(n,3)< 0
    OrbitalElements(n,5) = 360 - OrbitalElements(n,5);
end
OrbitalElements(n,6) = acosd(dot(ew(n,1:3),vec(n,1:3))/(OrbitalElements(n,2)*norm(vec(n,1:3))));
if dot(vec(n,1:3),vec(n,4:6)) < 0
    OrbitalElements(n,6) = 360 - OrbitalElements(n,6);
end
n=n+1;
end
tspan = [0:1:length];
subplot(3,2,1)
plot(tspan,OrbitalElements(:,1));
xlabel('Time (s)')
ylabel('Semi-Major Axis (km)')
title('Figure 1: Semi-Major Axis vs Time')
ylim([OrbitalElements(1,1)-1 OrbitalElements(1,1)+1])

subplot(3,2,2)
plot(tspan,OrbitalElements(:,2));
xlabel('Time (s)')
ylabel('Eccentricity')
title('Figure 2: Eccentricity')
ylim([OrbitalElements(1,2)-1 OrbitalElements(1,2)+1])

subplot(3,2,3)
plot(tspan,OrbitalElements(:,3));
xlabel('Time (s)')
ylabel('Inclincation Angle (Degrees)')
title('Figure 3: Inclination Angle (Degrees) vs Time')
ylim([OrbitalElements(1,3)-1 OrbitalElements(1,3)+1])

subplot(3,2,4)
plot(tspan,OrbitalElements(:,4));
xlabel('Time (s)')
ylabel('Longitude of Ascending Node (Degrees)')
title('Figure 4: LoAN vs Time')
ylim([OrbitalElements(1,4)-1 OrbitalElements(1,4)+1])

subplot(3,2,5)
plot(tspan,OrbitalElements(:,5));
xlabel('Time (s)')
ylabel('Argument of Periapsis (Degrees)')
title('Figure 5: AoP vs Time')
ylim([OrbitalElements(1,5)-1 OrbitalElements(1,5)+1])

subplot(3,2,6)
plot(tspan,OrbitalElements(:,6));
xlabel('Time (s)')
ylabel('True Anomaly (Degrees)')
title('Figure 6: True Anomaly vs Time')
ylim([0 360])

end
