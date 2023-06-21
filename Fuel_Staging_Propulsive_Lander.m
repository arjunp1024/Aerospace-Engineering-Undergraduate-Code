%% Fuel Staging Propulsive Lander
clear
hlch4_1 = 0;
hlox_1 = 0;
mpl1 = [14000]; %kg
OF1 = 6.03; %Oxidizer to fuel ratio

dv1 = 2500; %m/s

L = 1.5; %Length of area allocated for tanks

N1 = 1; %Number of engines
P1 = 33*10^6; %Pa
delta = .08;

%Engine
ISP1 = 400; %Specific Impulse
Thrust1 = 2.28*10^6; %Thrust per engine
Mengine_1 = 3177; %mass per engine
MThrustStructure_1 = (2.55*10^-4)*Thrust1;
MGimbals_1 = 237.8*((Thrust1/(P1)));


%We may now move onto starting stage 1, which will follow an extremely
%similar process, but this time using new parameters. I will copy the exact
%code from before and add in new comments where necessary details are
%needed

%Initial estimates
r1 = exp(-dv1/(9.81*ISP1));
lamba1 = r1 - delta;
mo1 = mpl1/lamba1; 
mi1_est = delta.*mo1;
mp1 = mo1.*(1-r1);


%Begin solving for necessary tank parameters
%As it doesn't make the most difference if we redefine these two variables
%now, I simply overwrite them. Also, note we are using LCH4 now
mlch4_1 = 1*mp1/(1+OF1);
mlox_1 = OF1*mp1/(1+OF1);

%From knowledge of how the tank mass of relates to propellant mass...
%From the way the lecture worded it, I assume LCH4 and LOX can be stored
%ina  similar manner as LH2 is a pain to store
rholox_1 = 1140;
rholch4_1 = 70.85;

mtanklch4_1 = 12.16*mlch4_1/rholch4_1;
mtanklox_1 = .0107*mlox_1;

%Also given is how insulation relates, but we need to find Area
vlox_1 = mlox_1/rholox_1;
vlch4_1 = mlch4_1/rholch4_1;
%Also given is how insulation relates, but we need to find Area


rlox_1 = (vlox_1./(4*pi/3)).^(1/3);
rlch4_1 = (vlch4_1./(4*pi/3)).^(1/3);


if (rlox_1>(L/2))
    rlox_1 = L/2;
    hlox_1 = (vlox_1 - (4*pi*(L/2)^3)/3)./(pi*(L/2)^2);
    alox_1 = 2*pi*(L/2).*hlox_1 + 2*pi*(L/2)^2;
else
    alox_1 = 4*pi*(rlox_1).^2;
end

if (rlch4_1>(L/2))
    rlch4_1 = L/2;
    hlch4_1 = (vlch4_1 - (4*pi*(L/2)^3)/3)/(pi*(L/2)^2);
    alch4_1 = 2*pi*(L/2)*hlch4_1 + 2*pi*(L/2)^2;
else
    alch4_1 = 4*pi*(rlch4_1).^2;
end    

minslox_1 = 1.123*alox_1;
minslch4_1 = 2.88*alch4_1;


%Fairings much easier to calculate as we just take the areas occupied by
%both the tanks and subtract them from the area of the cylinder
AreaFairings_1 = pi*70*L - (alox_1+alch4_1);
MFairings_1 = 4.95.*(AreaFairings_1).^1.15;


%Avionics and wiring
MAvionics_1 = 10*(mo1).^.361;
MWiring_1 = 1.058*sqrt(mo1).*(70^.25); %70 for the height of our rocket



mass_propellant_1 = mlox_1 + mlch4_1;


mi1_calculations = mtanklox_1 + mtanklch4_1 + minslox_1 + minslch4_1 + MFairings_1 + Mengine_1*N1 + MThrustStructure_1*N1 + MAvionics_1 + MWiring_1 +MGimbals_1;
margin1 = (mi1_est-mi1_calculations)./mi1_calculations;


total_m = mo1;
total_mi = mi1_calculations;

disp('The deltaV to be done by the lander is (in m/s): ')
disp(dv1)

disp('The total mass, in tons, is: ')
disp((total_m)/1000)

disp('The total inert mass, in tons, is: ')
disp((total_mi)/1000)

disp('The total LOX mass for Propulsive Lander is (in tons): ')
disp(mlox_1/1000)

disp('The LOX tank mass for Propulsive Lander is (in tons): ')
disp(mtanklox_1/1000)

disp('The total LCH4 mass for Propulsive Lander is (in tons): ')
disp(mlch4_1/1000)


if hlch4_1 == 0
    disp('Tank for Propulsive Lander LCH4 is Spherical with Radius (in m): ')
    disp(rlch4_1)
else
    disp('Tank for Propulsive Lander LCH4 is Cylndrical with Radius (in m): ')
    disp(rlch4_1)
    disp('and a Height of (in m):')
    disp(hlch4_1)
end

if hlox_1 == 0
    disp('Tank for Propulsive Lander LOX is Spherical with Radius (in m): ')
    disp(rlox_1)
else
    disp('Tank for Propulsive Lander LOX is Cylndrical with Radius (in m): ')
    disp(rlox_1)
    disp('and a Height of (in m):')
    disp(hlox_1)
end

% disp('The remaining mass is accounted by Fairings, Gimbals, Avionics, Engines, Thrust Structures, etc.')
%% Cost
%Assume cost of building 
number_of_modules = 4;
lox_cost = 1000; % $/kg rough estimate
lch4_cost = 1000; % $/kg rough estimate
inert_material_cost = 1; % $/kg of material
building_cost = 1000; % $ ?
%Assume learning curve of 80%
p = log(.8)/log(2);
if number_of_modules == 3
    c1 = building_cost;
    c2 = building_cost*(2^p);
    c3 = building_cost*(3^p);
    learning_adjusted_cost = c1 + c2 + c3;
elseif number_of_modules == 4
    c1 = building_cost;
    c2 = building_cost*(2^p);
    c3 = building_cost*(3^p);
    c4 = building_cost*(4^p);
    learning_adjusted_cost = c1 + c2 + c3 + c4;
elseif number_of_modules == 5
    c1 = building_cost;
    c2 = building_cost*(2^p);
    c3 = building_cost*(3^p);
    c4 = building_cost*(4^p);
    c5 = building_cost*(5^p);
    learning_adjusted_cost = c1 + c2 + c3 + c4 + c5;
end


lox_total_cost = lox_cost.*number_of_modules.*mlox_1;
lch4_total_cost = lch4_cost.*number_of_modules.*mlch4_1;
cost_inert = inert_material_cost.*number_of_modules.*mi1_calculations + learning_adjusted_cost;
total = lox_total_cost + lch4_total_cost + cost_inert;