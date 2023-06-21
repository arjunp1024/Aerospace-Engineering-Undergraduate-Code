function [Radiator_Specs] = Radiator_Calculations(radiator_material,powerhab,powerins,heat_metabolic_electrical,intensity_sunlight,margin)
boltzmann = 5.67*10^-8; %W/m2K4
%Area calculation
Radiator_Specs.Area = ((100+margin)*powerhab/100)/(boltzmann*radiator_material.emissivity*(radiator_material.max_temperature^4) + powerins + intensity_sunlight*radiator_material.absorptivity +heat_metabolic_electrical); %m^2
%Power to be radiated, including 30% margin on hab power
Radiator_Specs.Power_Absorbed = intensity_sunlight*radiator_material.absorptivity*Radiator_Specs.Area;
Radiator_Specs.Power = (100+margin)*powerhab/100 + powerins + Radiator_Specs.Power_Absorbed +heat_metabolic_electrical; %W
end
