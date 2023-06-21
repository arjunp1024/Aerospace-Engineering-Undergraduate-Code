function[Thermal_Insulation] = Thermal_Material(Material)
%Emissivity and Absorptivity are not as important, so some may have a value
%of 1, indicating it was not readily found
    if Material == 'Myla'
        %Mylar
        Thermal_Insulation.conductivity = .159; % W/(m*K)
        Thermal_Insulation.specific_heat = 1.17; % J/gK
    elseif Material == 'Kapt'
        %Kapton
        Thermal_Insulation.conductivity = .12; % W/(m*K)
        Thermal_Insulation.specific_heat = 1.09; % J/gK
    elseif Material == 'FPUR'
        %Polyurethane
        Thermal_Insulation.conductivity = .0215; % W/(m*K)
        Thermal_Insulation.specific_heat = 1.47; % J/gK
    elseif Material == 'Poly'
        %Polyethelyne
        Thermal_Insulation.conductivity = .038; % W/(m*K)
        Thermal_Insulation.specific_heat = 1.55; % J/gK
    elseif Material == 'Rego'
        %Regolith  
        Thermal_Insulation.conductivity = .01; % W/(m*K)
        Thermal_Insulation.specific_heat = 1.52; % J/gK
    end
end