function [Pump_Specs] = Pump_Specs(heat_need_radiated,efficiency)
heat_need_radiated = heat_need_radiated*(2 - efficiency)/1000; %convert to kW
Pump_Specs.mass_compressor = .202*heat_need_radiated; %kg
Pump_Specs.mass_evaporator = 2.72*heat_need_radiated; %kg
Pump_Specs.coolant_mass = 2;
Pump_Specs.total_mass = Pump_Specs.mass_compressor + Pump_Specs.mass_evaporator + Pump_Specs.coolant_mass; %kg
end