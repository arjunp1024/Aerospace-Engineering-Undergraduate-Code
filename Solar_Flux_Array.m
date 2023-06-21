function[dt,Solar_Flux] = Solar_Flux_Array(earth_days,longitude,latitude)
    TSI = 1363.03; %W/m^2
    dt = [0:3200/86400:earth_days];
    epsilon = dt*360/(29.53);
    h = asind(cosd(longitude)*cosd(epsilon));
    A = asind(sind(epsilon)/cosd(h));
    An = 90 - latitude; %???
    hp = 0; %???
    delta = acosd(sind(h)*sind(hp) + cosd(h)*cosd(hp)*cosd(An-A));
    %By the model, the Solar Flux at the equator with a tilt of latitude is
    %equal to the Solar Flux at said latitude
    Solar_Flux = TSI*cosd(delta); %W/m^2
    figure(3)
    plot(dt,Solar_Flux,'LineWidth',2)
    axis([0 earth_days 0 1600])
    xlabel('Time (days)')
    ylabel('Solar Flux (W/m^2)')
    title('Solar Flux vs Time')
end