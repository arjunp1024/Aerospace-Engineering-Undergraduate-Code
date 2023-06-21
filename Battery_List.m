function[Battery_Choice] = Battery_List(Battery)
    if Battery == 'Ni-Cd'
        Battery_Choice.energy_density = 80; % W-h/kg
        Battery_Choice.efficiency = .85;
        Battery_Choice.cost_density = .4; % $/W-h
    elseif Battery == 'Ni-H2'
        Battery_Choice.energy_density = 140; % W-h/kg
        Battery_Choice.efficiency = .85;
        Battery_Choice.cost_density = .083; % $/W-h
    elseif Battery == 'LiIon'
        Battery_Choice.energy_density = 260; % W-h/kg
        Battery_Choice.efficiency = .99;
        Battery_Choice.cost_density = .132; % $/W-h
    elseif Battery == 'Ni-MH'
        Battery_Choice.energy_density = 110; % W-h/kg
        Battery_Choice.efficiency = .90;
        Battery_Choice.cost_density = .250; % $/W-h
    end
end