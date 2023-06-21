function[Solar_Material] = Solar_Materials_List(Material)
    if Material == 'ITJ'
        Solar_Material.power_density = 948; % W/kg
        Solar_Material.efficiency = .265;
    elseif Material == 'UTJ'
        Solar_Material.power_density = 1013; % W/kg
        Solar_Material.efficiency = .283;
    elseif Material == 'XTJ'
        Solar_Material.power_density = 1074; % W/kg
        Solar_Material.efficiency = .3;
    elseif Material == 'NJ1'
        Solar_Material.power_density = 1181; % W/kg
        Solar_Material.efficiency = .33;
    end
end