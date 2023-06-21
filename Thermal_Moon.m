function [T_Moon,power_heat_cold,power_heat_hot,mass_insulation] = Thermal_Moon(latitude,temp_desired,earth_days,area1,area2,specific_heat,conductivity,thickness,density)
%Version 1.0
%Model for full lunar day or night
%Our target is to keep the inside temperature of the habitat at a desired
%temperature. We will input these variables to determine the power needed
%to maintain the habitat at our desired temperature as well as the
%temperature of our radiator
%
%Inputs of Latitude (Degrees), Solar Flux (W/m^2), Desired Temperature 
%(Celsius), Mission Length (Days), Area Radiating to Space (m^2), Area Radiating 
%partially to the Moon (m^2), Emissivity, Absorptivity, Thermal Diffusivity
%(m^2/s), Conductivity (W/mK), Wall Thickness (m), Metabolic+Electrical Heat Load (W)

%[T_Moon,T_Rad,Power] = Thermal_Moon(30,1300,20,14,50,50,.9,.6,4.5*10^-9,.01,.4,4600)
%Test code to see how it works, numbers based on Dr. Akin's Lecture as well
%as other research for Regolith. Copy code into different script file

%Fourier Equation for heat transfer through a wall

%Solution for Fourier's Heat Equation from Powell
%Need diffusivity

%https://asm.matweb.com/search/SpecificMaterial.asp?bassnum=ma7075t6
thermal_diffusivity1 = 130/(2810*0.96*1000)/1000; %MAKE SURE DENSITY IS kg//m^3
thermal_diffusivity2 = conductivity/(density*specific_heat*1000); %MAKE SURE DENSITY IS kg//m^3;

%For joint profile
n = 40; %nodes
T0 = 20; %C
dx1 = (5/1000)/n; %5 milimeter thickness aluminum
dx2 = thickness/n; %insulation

t_final = 86400*earth_days; %s
dt = .1; %s

%Aluminum
x1 = dx1/2:dx1:((5/1000)-dx1/2);
%Insulation
x2 = dx2/2:dx2:(thickness-dx2/2);

T1 = ones(n,1)*T0;
T2 = ones(n,1)*T0;

%Outer wall AKA aluminum thickness 5mm
dTdt1 = zeros(n,1);
%Inner wall AKA insulation thickness chosen
dTdt2 = zeros(n,1);

t = 0:dt:t_final;

T_Moon = zeros(n,1);
for i = 1:length(t)
    T_Moon(i) = 373.9*((cosd(latitude))^.25)*((sind(45*t(i)/(7*86400)))^.167); %From MacKay, in K
end

T_Moon_C = T_Moon - 273;
figure(1)
plot((t)./86400,T_Moon_C,'LineWidth',2)
xlabel('Time (days)')
ylabel('Temperature (C)')
title('Temperature on Lunar Surface')
[coldest,entrycold] = min(T_Moon_C(2:length(T_Moon_C)));
[hottest,entryhot] = max(T_Moon_C(2:length(T_Moon_C)));


for j = 1:length(t)
    for i = 2:n-1
        dTdt1(i) = thermal_diffusivity1*((-T1(i)+T1(i-1))/(dx1^2) + (T1(i+1)-T1(i))/(dx1^2));
        dTdt2(i) = thermal_diffusivity2*((-T2(i)+T2(i-1))/(dx2^2) + (T2(i+1)-T2(i))/(dx2^2));
    end
    %Update Inner wall, using the inner temp as the limiting condition
    dTdt2(1) = thermal_diffusivity2*((-T2(1)+(temp_desired))/(dx2^2) +(T2(2)-T2(1))/(dx2^2));
    dTdt2(n) = thermal_diffusivity2*((-T2(n)+T2(n-1))/(dx2^2) +(T1(1)-T2(n))/(dx2^2));
    T2 = T2 + dTdt2*dt;

    dTdt1(1) = thermal_diffusivity1*((-T1(1)+(T2(n)))/(dx1^2) +(T1(2)-T1(1))/(dx1^2));
    dTdt1(n) = thermal_diffusivity1*((-T1(n)+T1(n-1))/(dx1^2) +(T_Moon_C(j)-T1(n))/(dx1^2));
    T1 = T1 + dTdt1*dt;


%     figure(2)
%     plot(x1,T1,'LineWidth',1)
%     axis([0 5/1000 -150 150])
%     xlabel('Distance (m)')
%     ylabel('Temperature (C)')
%     title('Temperature Profile of Insulation Wall')

    if j == entrycold
        T_coldest1(:,1) = T1;
        T_coldest2(:,1) = T2;
    elseif j == entryhot
        T_hottest1(:,1) = T1;
        T_hottest2(:,1) = T2;
    end
end
figure(2)
hold on
x1 = x1 + thickness;
plot(x1,T_coldest1(:,1),'LineWidth',2)
plot(x2,T_coldest2(:,1),'LineWidth',2)
plot(x1,T_hottest1(:,1),'LineWidth',2)
plot(x2,T_hottest2(:,1),'LineWidth',2)
legend('Coldest Aluminum','Coldest Insulation','Hottest Aluminum','Hottest Insulation')
    axis([0 max(x1) -250 50])
    xlabel('Distance (m)')
    ylabel('Temperature (C)')
    title('Temperature Profile of Insulation Wall')
coeff_cold1 = polyfit(x2,T_coldest2,1);
coeff_hot1 =  polyfit(x2,T_hottest2,1);
flux_cold1 = coeff_cold1(1);
flux_hot1 = coeff_hot1(1);
hold off

%For joint profile (thickness decreased)
n2 = 40; %nodes
T0 = 20; %C
dx3 = (5/1000)/n2; %5 milimeter thickness aluminum
thickness_overall = thickness*(.5);
dx4 = thickness_overall/(n2); %insulation

%Aluminum
x3 = dx3/2:dx3:((5/1000)-dx3/2);
%Insulation
x4 = dx4/2:dx4:(thickness_overall -dx4/2);

T3 = ones(n,1)*T0;
T4 = ones(n,1)*T0;

%Outer wall AKA aluminum thickness 5mm
dTdt3 = zeros(n,1);
%Inner wall AKA insulation thickness chosen
dTdt4 = zeros(n,1);

for j = 1:length(t)
    for i = 2:n2-1
        dTdt3(i) = thermal_diffusivity1*((-T3(i)+T3(i-1))/(dx3^2) + (T3(i+1)-T3(i))/(dx3^2));
        dTdt4(i) = thermal_diffusivity2*((-T4(i)+T4(i-1))/(dx4^2) + (T4(i+1)-T4(i))/(dx4^2));
    end
    %Update Inner wall, using the inner temp as the limiting condition
    dTdt4(1) = thermal_diffusivity2*((-T4(1)+(temp_desired))/(dx4^2) +(T4(2)-T4(1))/(dx4^2));
    dTdt4(n2) = thermal_diffusivity2*((-T4(n2)+T4(n2-1))/(dx4^2) +(T3(1)-T4(n2))/(dx4^2));
    T4 = T4 + dTdt4*dt;

    dTdt3(1) = thermal_diffusivity1*((-T3(1)+(T4(n2)))/(dx3^2) +(T3(2)-T3(1))/(dx3^2));
    dTdt3(n2) = thermal_diffusivity1*((-T3(n2)+T3(n2-1))/(dx3^2) +(T_Moon_C(j)-T3(n2))/(dx3^2));
    T3 = T3 + dTdt3*dt;


%     figure(2)
%     plot(x1,T1,'LineWidth',1)
%     axis([0 5/1000 -150 150])
%     xlabel('Distance (m)')
%     ylabel('Temperature (C)')
%     title('Temperature Profile of Insulation Wall')

    if j == entrycold
        T_coldest3(:,1) = T3;
        T_coldest4(:,1) = T4;
    elseif j == entryhot
        T_hottest3(:,1) = T3;
        T_hottest4(:,1) = T4;
    end
end
figure(3)
hold on
x3 = x3 + thickness_overall;
plot(x3,T_coldest3(:,1),'LineWidth',2)
plot(x4,T_coldest4(:,1),'LineWidth',2)
plot(x3,T_hottest3(:,1),'LineWidth',2)
plot(x4,T_hottest4(:,1),'LineWidth',2)
legend('Coldest Aluminum','Coldest Insulation','Hottest Aluminum','Hottest Insulation')
    axis([0 max(x3) -250 50])
    xlabel('Distance (m)')
    ylabel('Temperature (C)')
    title('Temperature Profile of Insulation Wall')
coeff_cold2 = polyfit(x4,T_coldest4,1);
coeff_hot2 =  polyfit(x4,T_hottest4,1);
flux_cold2 = coeff_cold2(1);
flux_hot2 = coeff_hot2(1);
hold off
%Power needed to maintain hab at desired temperature bc insulation
power_heat_cold = (conductivity*area1*flux_cold1 + conductivity*area2*flux_cold2);
power_heat_hot = (conductivity*area1*flux_hot1 +conductivity*area2*flux_hot2);
%Mass
%Mass will be the volume*density
mass_insulation = (area1*thickness + area2*thickness_overall)*density;
end