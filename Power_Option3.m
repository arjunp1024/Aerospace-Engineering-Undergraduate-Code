function [Result] = Power_Option3(flux_array,solar_material,battery_material,power_hab_active,power_rover_active,power_rover_inactive,hours_rover,margin)
%Using all of the other inputs, we must calculate the minimum power needed
%to operate for x amount of days and inactive use of (365-x)

%Location
%Based on location, we will have different intensities of the sun.
%For our calculations, we need to consider the minimal amount of power we
%can generate. We can then do calculations accounting for the lowest point
intensity_sun_min = min(flux_array);
n = margin+100; 

%Let us examine a few options: Active use only by solar panels, batteries
%or Nuclear Reactor

power_absolute = power_hab_active + power_rover_active; %W


%Only Solar Panel for 5 days in sunlight
%Power to operate comfortably (i.e. over the desired margin)
Result.Solar_Power_Active = power_absolute*n/100;
%Mass needed to supply this Power
Result.Solar_Mass_Active = Result.Solar_Power_Active/solar_material.power_density;
%Area needed to supply this Power
Result.Solar_Area_Active = Result.Solar_Power_Active/(intensity_sun_min*solar_material.efficiency);
%Cost, as a result
Result.Solar_Cost_Active = 10000*Result.Solar_Area_Active;

%Only Batteries
Result.Battery__Mass_Active = (power_absolute*n/100)*5*24/(battery_material.energy_density*battery_material.efficiency); %kg
Result.Battery__Cost_Active = (power_absolute*n/100)*5*24*battery_material.cost_density; %$

%Only Nuclear Reactors
%We can only estimate the cost, but that should be sufficient 
Result.Nuclear_Cost_Active = (power_absolute*n/100)*5000000/40000; %$
Result.Nuclear_Mass_Active = (power_absolute*n/100)*6500/40000; %kg
%We can obviously see we should run with Solar Panels for active use, and
%operate with batteries in inactive use situations when applicable

%We already have our necessary items for active use, and that will more
%than suffice for an inactive use for the remaining 9 days of sunlight. 

%Additionally, we should have emergency batteries for 48 hours of continued use.
Result.Battery_Emergency_Mass = (power_hab_active*n/100)*48/(battery_material.energy_density*battery_material.efficiency); %kg
Result.Battery_Emergency_Cost = (power_hab_active*n/100)*48*battery_material.cost_density; %$

%And finally, we can calculate the batteries needed to maintain the hab and
%rover in inactive use when we have no solar power (ie, half the year). We
%will be recharging the batteries during daytime, so we only need the
%batteries to be charged for a 14 day window
%For the rest of the time, we can rely on the solar panels to operate

%Inactive use and no Solar Power APPLICABLE IF WE CHANGE SITES
%Result.Battery__Mass_Inactive = (power_absolute_inactive*n/100)*(14*24)/(battery_material.energy_density); %kg
%Result.Battery__Cost_Inactive = (power_absolute_inactive*n/100)*(14*24)*battery_material.cost_density; %$

%During time where we are inactive, we can charge the batteries
Result.Rover_Active_Mass = (power_rover_active*n/100)*hours_rover/(battery_material.energy_density*battery_material.efficiency); %kg
Result.Rover_Active_Cost = (power_rover_active*n/100)*hours_rover*battery_material.cost_density; %$

%Charge of inactive use of Rover
%These will be constantly charged by its own separate solar panels
Result.Rover_Inactive_Mass = (power_rover_inactive*n/100)*1/(battery_material.energy_density*battery_material.efficiency); %kg
Result.Rover_Inactive_Cost = (power_rover_inactive*n/100)*1*battery_material.cost_density; %$


Result.Total_Cost = Result.Solar_Cost_Active + Result.Battery_Emergency_Cost + Result.Rover_Active_Cost + Result.Rover_Inactive_Cost;
Result.Total_Mass = Result.Solar_Mass_Active + Result.Battery_Emergency_Mass + Result.Rover_Active_Mass + Result.Rover_Inactive_Mass;
disp('The total cost would be (in $): ')
disp(Result.Total_Cost)
disp('The total mass would be (in kg): ')
disp(Result.Total_Mass)


end
