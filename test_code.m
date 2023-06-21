%CODE THAT CAN BE COPIED AND PASTED AS A SCRIPT
%ALL FILES IN FOLDER MUST BE SAVED TO A PATH FOR MATLAB
clear
n = 30; %margin desired

people = 6;

transmitters = 2;

duration_days = 28; %days

duration_hours = duration_days*24; %hours

duration_mission = 5; %days

hours_rover = 3;

%Insulation Thickness and Density
thickness = .02; %m
insulation_density = 500; %kg/m^3

%Desired Internal Temperature
temp_desired = 20; %C

%Location
latitude = 84.35; %deg
longitude = 10.07; %deg
[dt,sol] = Solar_Flux_Array(duration_days,longitude,latitude);

%Solar Materials, options of NJ1 ITJ UTJ XTJ
solar_material = Solar_Materials_List('NJ1');

%Battery Materials, options of Ni-Cd Ni-H2 LiIon Ni-MH
battery_material = Battery_List('LiIon');

%Power Necessities
power_hab_active = 27000; %W
power_rover_active = 10000; %W
power_rover_inactive = 1926; %W

%Heat from Metabolic
heat_metabolic = 7000; %W

%Insulation Materials, options of Poly Myla Kapt FPUR Rego
insulation_material = Thermal_Material('Poly');

%Radiator Materials, really is just Alum
%Design Constraint is the max temperature allowed for the material chosen
radiator_material = Radiator_Material('Alum');

%Thermal Moon Code, finds profile of temperature

%From NX
total_area = (49241844 + 70575719/2)/(1000^2) + (46512867 + 70575719/2)/(1000^2);
%m2, area of habitat covered by radiation protection material
area1 = total_area*(3016/insulation_density)/(((pi*((3+thickness)^2)*(6) + 4*pi*((3+thickness)^3)/3) - (pi*(3^2)*6 + 4*pi*(3^3)/3)));
%m2, remaining area
area2 =  total_area - area1;
[T_Moon,Power_Heat_Cold,Power_Heat_Hot,mass_insulation] = Thermal_Moon(latitude,temp_desired,duration_days,area1, ...
    area2,insulation_material.specific_heat,insulation_material.conductivity,thickness, ...
    insulation_density);

Power_Active = (power_hab_active);

%Power Option, finds parameters for how our Power System works
%Note that duration is NOT needed as we have a set mission time of 5 days
[Result] = Power_Option3(sol,solar_material,battery_material,Power_Active,power_rover_active,power_rover_inactive,hours_rover,n);

%Radiator Calculation
%We have a max temperature we can use for the radiator, thus we need to
%calculate the minimum area needed
%Q to radiate = Qhab + Qins + Qsolar
%To perform Rover calcs, change QHab and Qins to be that of Rover
[Radiator_Specs] = Radiator_Calculations(radiator_material,Power_Active,Power_Heat_Hot,heat_metabolic,max(sol),n);

%Pump Calculations
%Determined by EES
Pump_Efficiency = 0.5633;
Pump_Heat = Radiator_Specs.Power;
[Pump_Specs] = Pump_Specs(Pump_Heat,Pump_Efficiency);

diameter_pipe = 125; %mm
thickness_pipe = 2; %mm

%Inner radius allowable for the coolant
inner_radius = .1; %m
%Let's say that the pumps cover about 25% of the habitat
area_coolant = .1*(area1+area2); %m^2
%Inner diamter*length = area covered
length_coolant = area_coolant/(inner_radius*2);

%https://asm.matweb.com/search/SpecificMaterial.asp?bassnum=ma6061o
density_pipe = 2.7*10^-6; %kg/mm^3


area_pipe = pi*(diameter_pipe^2 - (diameter_pipe- 2*thickness_pipe)^2)/4; %mm^2
volume_pipe = area_pipe*length_coolant*1000;
Pump_Specs.mass_pipe = density_pipe*volume_pipe;
%Plot solar flux array
figure(4)
plot(dt,sol,'LineWidth',2)
axis([0 28 0 1600])
xlabel('Time (days)')
ylabel('Solar Flux (W/m^2)')
title('Solar Flux vs Time')