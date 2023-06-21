%% Propulsive Lander Calculations
clear
%% Beams/Frame
diameter = 114.3; %mm
thickness = 6; %mm

%https://asm.matweb.com/search/SpecificMaterial.asp?bassnum=ma6061o
density = 2.7*10^-6; %kg/mm^3


area = pi*(diameter^2 - (diameter- 2*thickness)^2)/4; %mm^2
%Diagonal Beams
n_diagonal_inner = 8;
l_diagonal_inner = 4709.2063; %mm
total_length = n_diagonal_inner*l_diagonal_inner;

n_diagonal_outer = 8;
l_diagonal_outer = 5064.6791; %mm
total_length = n_diagonal_outer*l_diagonal_outer + total_length;

%Horizontal Beams
n_horizontal_inner = 16;
l_horizontal_inner = 2485.281375; %mm
total_length = n_horizontal_inner*l_horizontal_inner + total_length;

n_horizontal_outer = 16;
l_horizontal_outer = 3106.601718; %mm
total_length = n_horizontal_outer*l_horizontal_outer + total_length;

%Vertical Beams
n_vertical = 16;
l_vertical = 4000; %mm
total_length = n_vertical*l_vertical + total_length;

%Connector Beams
n_connector = 16;
l_connector = 811.794149285; %mm
total_length = n_connector*l_connector + total_length;

total_volume = area*total_length;

mass_frame = total_volume*density; %kg
%This is for 10mm panels, reduce to 2
mass_panels = (389.2269*8 + 486.5336*8 + 82.1025*16)/5;
%% Fuel Staging Propulsive Lander
hlch4_1 = 0;
hlox_1 = 0;
mpl1 = [14000]; %kg
OF1 = 3.3; %Oxidizer to fuel ratio

dv1 = 2500; %m/s

L = .75; %Length of area allocated for tanks

delta = .08;

%Engine
ISP1 = 374.02909; %Specific Impulse



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
rholch4_1 = 430;

mtanklch4_1 = 12.16*mlch4_1/rholch4_1;
mtanklox_1 = .0107*mlox_1;

%Also given is how insulation relates, but we need to find Area
vlox_1 = mlox_1/rholox_1;
vlch4_1 = mlch4_1/rholch4_1;

%tanks 4 meters tall, radius limited by area allotted to create lander

rlox_1 = L/2;
rlch4_1 = L/2;
hlox_1 = 4;
hlch4_1 = 4;

alox_1 = 2*pi*(rlox_1).*hlox_1 + 2*pi*(rlox_1)^2;
alch4_1 = 2*pi*(rlch4_1).*hlch4_1 + 2*pi*(rlch4_1)^2;

vlox_single = hlox_1*(pi*(rlox_1)^2) + (4*pi*(rlox_1)^3)/3;
vlch4_single = hlch4_1*(pi*(rlch4_1)^2) + (4*pi*(rlch4_1)^3)/3;

n_lox_tanks = ceil(vlox_1/vlox_single);
n_lch4_tanks = ceil(vlch4_1/vlch4_single);


minslox_1 = 1.123*alox_1;
minslch4_1 = 2.88*alch4_1;


%Fairings through NX


%Avionics and wiring
MAvionics_1 = 10*(mo1).^.361;
MWiring_1 = 1.058*sqrt(mo1).*(4^.25); %70 for the height of our rocket

%Engine Mass
Mengine_1 = 144.26; %mass per engine
N1 = 4; %Number of engines
Thrust1 = (31.65876*10^3); %Thrust per engine
MThrustStructure_1 = (2.55*10^-4)*Thrust1;

P1 = 4*10^6; %Pa
MGimbals_1 = 237.8*((Thrust1/(P1))); %kg


mi1_calculations = mtanklox_1*n_lox_tanks + mtanklch4_1*n_lch4_tanks + minslox_1 + minslch4_1 + Mengine_1*N1 + MThrustStructure_1*N1 + MAvionics_1 + MWiring_1 + MGimbals_1*4;
margin1 = (mi1_est-mi1_calculations)./mi1_calculations;


burn_time = mlox_1/6.62389; %s

total_m = mo1;
total_mi = mi1_calculations;
%% Total Mass
Total_Mass = mi1_calculations + mass_frame + mass_panels;
disp('The total mass for the lander (frame, tanks, panels, wiring, thrust structure, thrusters) is (in kg):')
disp(Total_Mass)
disp('The total propellant mass for this lander is (in kg): ')
disp(mp1)
disp('The mass of LOX is (in kg): ')
disp(mlox_1)
disp('The mass of LCH4 is (in kg): ')
disp(mlch4_1)
disp('The fully loaded lander mass is (in kg): ')
disp(Total_Mass + mp1)
disp('The Burn time for this mission would be (in s): ')
disp(burn_time)
disp('The radius and height of the LOX tank are (respectively, and in m): ')
disp(rlox_1)
disp(hlox_1)
disp('The radius and height of the LCH4 tank are (respectively, and in m): ')
disp(rlch4_1)
disp(hlch4_1)
disp('The number of LOX tanks is: ')
disp(n_lox_tanks)
disp('The number of LCH4 tanks is: ')
disp(n_lch4_tanks)
%% Mass breakdown
disp('Mass of beams')
disp(mass_frame)
disp('Mass of panelling')
disp(mass_panels)
disp('Avionics')
disp(MAvionics_1)
disp('LOX Tanks')
disp(mtanklox_1*n_lox_tanks)
disp('LCH4 Tanks')
disp(mtanklch4_1*n_lch4_tanks)
disp('LOX insulation')
disp(minslox_1)
disp('LCH4 insulation')
disp(minslch4_1)
disp('Nozzle')
disp(Mengine_1*N1)
disp('Thrust Structure')
disp(MThrustStructure_1*N1)
disp('Gimbals')
disp(MGimbals_1*N1)
disp('Wiring')
disp(MWiring_1)
disp('Mass LOX')
disp(mlox_1)
disp('Mass LCH4')
disp(mlch4_1)