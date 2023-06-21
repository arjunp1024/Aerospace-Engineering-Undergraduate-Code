function[Radiation_Options] = Radiator_Material(Material)
%Emissivity and Absorptivity
    if Material == 'Alum'
        %Aluminum
        %https://space.nss.org/settlement/nasa/spaceresvol2/thermalmanagement.html
        Radiation_Options.emissivity = .86;
        %https://www.engineeringtoolbox.com/radiation-surface-absorptivity-d_1805.html
        Radiation_Options.absorptivity = .65; %Not applicable
        Radiation_Options.max_temperature = 700; %K
    end
end