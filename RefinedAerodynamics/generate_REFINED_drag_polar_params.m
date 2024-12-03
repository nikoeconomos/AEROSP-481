% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_REFINED_drag_polar_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the drag polar of the aerodynamics system of the aircraft based
% on an optimized airfoil.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with drag polar
%    parameters
%                       
% 
% See also: None
% Author:                          Victoria
% Version history revision notes:
%                                  v1: 11/8/2024

% Need to calculate drag at each component, then add together for total
% drag

%%%%%%%%%%%%%%%%%%%%
%% INITIALIZATION %%
%%%%%%%%%%%%%%%%%%%%

aircraft = generate_CL_params(aircraft);

wing = aircraft.geometry.wing;
aero = aircraft.aerodynamics;
htail = aircraft.geometry.htail;

% For all aircraft aspects - Given in table in drive under utilities
S_ref_wing = wing.S_ref; % [m^2]

freestream_mach = aircraft.performance.mach.arr; %0.282 0.54 0.85 0.9 1.2 1.6

wing_airfoil_mach = freestream_mach.*cos(aircraft.geometry.wing.sweep_LE);

[~, ~, ~, a_SL]    = standard_atmosphere_calc(0);
[~, ~, ~, a_6000]  = standard_atmosphere_calc(6000);
[~, ~, ~, a_10600] = standard_atmosphere_calc(10600);
speed_of_sound = [a_SL a_6000 a_10600 a_10600 a_10600 a_10600];

kinematic_viscosity = [0.00001461 0.00002416 0.00003706 0.00003706 0.00003706 0.00003706];

Cf_turbulent_calc = @(Re) 0.455 ./ ((log10(Re)).^2.58 .* (1 + 0.144 .* freestream_mach.^2).^0.65); % turbulent

%%%%%%%%%%%%%%%%%%%%%%
%% CD0 CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%

%% Fuselage %%

% Aircraft parameters
l_fuselage     = aircraft.geometry.fuselage.length;
S_wet_fuselage = aircraft.geometry.fuselage.S_wet; % [m^2]
A_max_fuselage = aircraft.geometry.fuselage.A_max; % Estimated cross-sectional area

Q_fuselage     = 1; % Interference factor, given on slide 16 of lecture 14

Re_fuselage = speed_of_sound .* wing_airfoil_mach .* l_fuselage ./ kinematic_viscosity
%Re_fuselage_values = [72630000, 81690000, 75060000, 81320000, 87570000, 93830000, 100090000, 112600000, 125110000, 131360000, 137620000, 141370000, 150130000];

% Skin friction coefficients - from slides
Cf_fuselage = Cf_turbulent_calc(Re_fuselage);

% No laminar flow as we're a camoflaged fighter jet
% x_laminar = 0; % Estimated from slide 11 of lecture 14 (military jet with camo = 0)
% Cf_fuselage_laminar   = 1.328 ./ sqrt(Re_fuselage);
% Cf_fuselage_effective = x_laminar * Cf_fuselage_laminar + (1 - x_laminar) * Cf_fuselage_turbulent;

% Fineness ratio and form factor for fuselage, slide 13
f_fuse = l_fuselage / sqrt(4 * pi * A_max_fuselage);
FF_fuselage = 0.9 + (5 / (f_fuse^1.5)) + (f_fuse / 400); 

CD0_fuselage = ((Cf_fuselage .* FF_fuselage .* Q_fuselage .* S_wet_fuselage) / S_ref_wing);

%% Inlets %%

%{ 
%Inlet parameters
l_inlet     = aircraft.geometry.inlet.length; % [m]
S_wet_inlet  = aircraft.geometry.inlet.S_wet; % [m^2], Estimated
A_max_inlet = aircraft.geometry.inlet.A_max;

Q_inlet = 1; % Assumed 1

Re_inlet = Re_fuselage * (l_inlet / l_fuselage); 

Cf_inlet = Cf_turbulent_calc(Re_inlet);

% Form factor
f_inlet  = l_inlet / sqrt(4 * pi * A_max_inlet); 
FF_inlet = 0.9 + (5 / (f_inlet^1.5)) + (f_inlet / 400); 

CD0_inlets = ((Cf_inlet * FF_inlet * Q_inlet * S_wet_inlet) / S_ref_wing) * 2; % Two inlets, multiply by two
%}


%% Wings (Both) %%

% Wing parameters
S_wet_wing = aircraft.geometry.wing.S_wet; % [m^2]
Q_wing    = 1; % Assumed 1 for a mid-wing configuration

loc_max_thickness_wing = aircraft.geometry.wing.chordwise_loc_max_thickness; % [unitless]
t_c_wing               = aircraft.geometry.wing.t_c_root; % Average is 6%

sweep_HC_wing = aircraft.geometry.wing.sweep_HC; % [degrees] Sweep angle of max thickness line
MAC_wing      = aircraft.geometry.wing.MAC; % [m] chord

Re_wing = Re_fuselage * (MAC_wing / l_fuselage);

Cf_wing = Cf_turbulent_calc(Re_wing);

FF_wing = (1 + (0.6 / (loc_max_thickness_wing)) * (t_c_wing) + 100 * (t_c_wing)^4) * (1.34 * freestream_mach.^0.18 * cos(sweep_HC_wing)^0.28);

CD0_wing = (Cf_wing .* FF_wing * Q_wing * S_wet_wing) ./ S_ref_wing;

%% Horizontal Stabilizer (Both) %%

% Horizontal stabilizer parameters
S_wet_htail = aircraft.geometry.htail.S_wet; % [m^2]
Q_htail = 1.0; % Assumed 1

loc_max_thickness_htail  = aircraft.geometry.htail.chordwise_loc_max_thickness; % [unitless]
t_c_htail                = aircraft.geometry.htail.t_c_root; % Average is 6%

sweep_HC_htail = aircraft.geometry.htail.sweep_HC; % [degrees] Sweep angle of max thickness line
MAC_htail      = aircraft.geometry.htail.MAC; % [m]

Re_htail = Re_fuselage * (MAC_htail / l_fuselage);

Cf_htail = Cf_turbulent_calc(Re_htail);

FF_htail = (1 + (0.6 / (loc_max_thickness_htail)) * (t_c_htail) + 100 * (t_c_htail)^4) * (1.34 * freestream_mach.^0.18 * cos(sweep_HC_htail)^0.28);

CD0_htail = (Cf_htail .* FF_htail * Q_htail * S_wet_htail) ./ S_ref_wing;

%% Vertical Stabilizer (Both) %%

% Horizontal stabilizer parameters
S_wet_vtail = aircraft.geometry.vtail.S_wet; % [m^2]
Q_vtail = 1.0; % Assumed 1

loc_max_thickness_vtail  = aircraft.geometry.vtail.chordwise_loc_max_thickness; % [unitless]
t_c_vtail                = aircraft.geometry.vtail.t_c_root; % Average is 6%

sweep_HC_vtail = aircraft.geometry.vtail.sweep_HC; % [degrees] Sweep angle of max thickness line
MAC_vtail      = aircraft.geometry.vtail.MAC; % [m]

Re_vtail = Re_fuselage * (MAC_vtail / l_fuselage);

Cf_vtail = Cf_turbulent_calc(Re_vtail);

FF_vtail = (1 + (0.6 / (loc_max_thickness_vtail)) * (t_c_vtail) + 100 * (t_c_vtail)^4) * (1.34 * freestream_mach.^0.18 * cos(sweep_HC_vtail)^0.28);

CD0_vtail = (Cf_vtail .* FF_vtail * Q_vtail * S_wet_vtail) ./ S_ref_wing;

%% Landing Gear

% Raymer table 12.6
streamline_wheel_tire_per_area = 0.18;
streamlined_strut_per_area = 0.05;

%frontal areas pulled from cad sketch of lg 11/24/2024
main_wheel_frontal_area = 0.158; %m^2 all from CAD
nose_wheel_frontal_area = 0.065;
main_strut_frontal_area = 0.165;
nose_strut_frontal_area = 0.071;

CD0_main_wheels = streamline_wheel_tire_per_area * main_wheel_frontal_area * 2;
CD0_nose_wheels = streamline_wheel_tire_per_area * nose_wheel_frontal_area * 2;
CD0_main_struts = streamlined_strut_per_area     * main_strut_frontal_area * 2;
CD0_nose_strut  = streamlined_strut_per_area     * nose_strut_frontal_area * 1; % only one of these

CD0_lg = CD0_main_wheels + CD0_nose_wheels + CD0_main_struts + CD0_nose_strut;

%% Miscellaneous Drag %%

CD0_misc = 0; % Assumed to be zero because no main sources apply to our aircraft

%% Leakage and Protuberance Drag %%

CD0_lp = 0.05; % Estimated from table in slides slide 20

%% Flap Drag %%

F_flap = 0.0144; % for plain flaps, lecture 14 slide 24

cf_c = aircraft.geometry.wing.c_flapped_over_c; % ratio of flapped chord to chord

S_flapped = aircraft.geometry.wing.S_flapped; % [m^2]

flap_deflect_takeoff = aircraft.geometry.wing.flap_deflect_takeoff;
flap_deflect_landing = aircraft.geometry.wing.flap_deflect_landing;

delta_CD0_takeoff_flaps_slats = F_flap * (cf_c) * (S_flapped / S_ref_wing) * (rad2deg(flap_deflect_takeoff) - 10);
delta_CD0_landing_flaps_slats = F_flap * (cf_c) * (S_flapped / S_ref_wing) * (rad2deg(flap_deflect_landing) - 10);

%% Total Parasitic Drag Calc %%

CD0_component_sum  = CD0_fuselage + CD0_wing  + CD0_htail + CD0_vtail; %+ CD0_inlets;

aero.CD0.clean = CD0_component_sum(3) + CD0_misc + CD0_lp; 

aero.CD0.takeoff_flaps_slats      = aero.CD0.clean + delta_CD0_takeoff_flaps_slats;
aero.CD0.takeoff_flaps_slats_gear = aero.CD0.takeoff_flaps_slats + CD0_lg;

aero.CD0.landing_flaps_slats      = aero.CD0.clean + delta_CD0_landing_flaps_slats;
aero.CD0.landing_flaps_slats_gear = aero.CD0.landing_flaps_slats + CD0_lg;

%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE e VALUES %%
%%%%%%%%%%%%%%%%%%%%%%%%

aero.e.clean               = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.clean, 0, 0.98);
aero.e.takeoff_flaps_slats = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.takeoff_flaps_slats, 0, 0.98);
aero.e.landing_flaps_slats = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.landing_flaps_slats, 0, 0.98);

aero.e.htail = 1.78 * (1 - (0.045 * aircraft.geometry.htail.AR^0.68) ) - 0.64; % from the presentation slide 26

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIFT INDUCED DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AR_wing = aircraft.geometry.wing.AR;

aero.CDi.cruise             = aero.CL.cruise^2              / (pi * AR_wing * aero.e.clean);
aero.CDi.takeoff_flaps_slats = aero.CL.takeoff_flaps_slats^2 / (pi * AR_wing * aero.e.takeoff_flaps_slats);
aero.CDi.landing_flaps_slats = aero.CL.landing_flaps_slats^2 / (pi * AR_wing * aero.e.landing_flaps_slats);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIM DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CMac_w spanwise points to integrate over 12 points, sectional Cl 12 
% simulations

Kf = 0.033; % Fusselage pitching moment factor obtained from table from NACA TR 711 with %l_fus = 0.55
Wf = 2.4; % Max fusselage width

CM_fus_coeff = Kf * l_fuselage * Wf^2 / (wing.MAC * ...
    wing.S_ref);

CM_fus_SLF = CM_fus_coeff * 0;
CM_fus_TO = CM_fus_coeff * 12;
CM_fus_L = CM_fus_coeff * 16;

xt = htail.xMAC + 0.25 * htail.MAC;
xw = wing.xMAC + 0.25 * wing.MAC;

xt_comp = htail.xMAC + 0.5 * htail.MAC;
xw_comp = wing.xMAC + 0.5 * wing.MAC;

wing_chords = linspace(wing.c_root, wing.c_tip, 12);

b = linspace(0, (wing.b/2)-1.3,12); % Evenly spaced points along single wing span

b_xloc = linspace(1.3, wing.b/2,12); % To figure out x displacements along wing by using sweep

x_root = 1.3 .* tan(wing.sweep_QC);
x_root_comp = 1.3 .* tan(wing.sweep_HC);

x_ac = b_xloc .* tan(wing.sweep_QC) - x_root;

% Update value for M = 1.6 (only flight point at which airfoil sees supersonic flow)
x_ac_comp = b_xloc .* tan(wing.sweep_HC) - x_root_comp;

Re_chords = Re_fuselage' * wing_chords / l_fuselage;

% Changes in Cl along span are small for all but twisted sections at wing
% tip where airfoil AoA = 0 (last 2)
Cl = [0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.5279586, 0.3000464, 0.3000464; % M = 0.282 TO
1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.300741, 1.141948, 1.141948; ... % M = 0.282 L
0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.5545099, 0.3118555, 0.3118555; ... % 0.54
0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.6088894, 0.3456586, 0.3456586; ... % 0.85
0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.6550923, 0.3568663, 0.3568663; ... % 0.9
0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.7320457, 0.4254425, 0.4254425; ... % 1.2
0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, 0.2170855, -0.02614533, -0.02614533; ... % 1.6
0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9020024, 0.9065286, 0.9065286; ... % Del TO flaps
0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.524337, 0.567356, 0.567356]; % Del L flaps

% Changes in Cm along span are small for all but twisted sections at wing
% tip where airfoil AoA = 0 (last 2)

Cm_ac = [-0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.0794227, -0.07812929, -0.07812929; % M = 0.282 TO
-0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.05963526, -0.06916824, -0.06916824; ... % M = 0.282 L
-0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08260348, -0.08149004, -0.08149004; ... % 0.54
-0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.08520622, -0.09074765, -0.09074765; ... % 0.85
-0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.0932449, -0.09374932, -0.09374932; ... % 0.9
-0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1694612, -0.1518031, -0.1518031; ... % 1.2
-0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.1090707, -0.02614533, -0.02614533; ...; % 1.6
-0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.2471044, -0.24567651, -0.24567651; ... % Del TO flaps
-0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19837374, -0.19649686, -0.19649686]; % Del L flaps

CM_ac_w = zeros(1,9);

CM_ac_minus_tail = zeros(1,7);

CL_tail = zeros(1,7);

CD_trim = zeros(1,7);

CM_norm = 1 / (wing.MAC * wing.S_ref); % Normalize CM_ac_w integrals by wing dimensions

CL_t_coeff = xt / (htail.volume_coefficient * (xt - xw));

CL_t_coeff_comp = xt_comp / (htail.volume_coefficient * (xt_comp - xw_comp));

%aircraft.aerodynamics.CL.combat = 0.9 * 0.2170855; % HOPEFULLY THIS WILL
%ENLARGE OUR DESIGN SPACE MAINEFEST!!!!! B-)

CL_wing = [aero.CL.takeoff_flaps_slats, aero.CL.landing_flaps_slats, 0.9 * 0.5545099, ...
    aero.CL.cruise, 0.9 * 0.6550923, 0.9 * 0.7320457, 0.9 * 0.2170855];

for k = 1:length(CM_ac_w)
    
    left_func = Cl(k,:) .* wing_chords .* x_ac;
    right_func = Cm_ac(k,:) .* wing_chords.^2;

    if k == 7
        left_func = Cl(k,:) .* wing_chords .* x_ac_comp;
    end

    left_int = -2 * trapz(left_func, b);

    right_int = 2 * trapz(right_func, b);

    CM_ac_w(k) = CM_norm * (left_int + right_int);

end

for j = 1:length(CL_tail)
    
    if j == 1
        CM_ac_minus_tail(j) = CM_ac_w(j) + CM_fus_TO + CM_ac_w(7);
    elseif j == 2
        CM_ac_minus_tail(j) = CM_ac_w(j) + CM_fus_L + CM_ac_w(8);
    else
        CM_ac_minus_tail(j) = CM_ac_w(j) + CM_fus_SLF;
    end
    
    
    if j == 7
        CL_tail(j) = (CL_wing(j) * (xw / wing.MAC) + CM_ac_minus_tail(j)) * CL_t_coeff;
    else
        CL_tail(j) = (CL_wing(j) * (xw_comp / wing.MAC) + CM_ac_minus_tail(j)) * CL_t_coeff_comp;
    end

    CD_trim(j) = CL_tail(j)^2 * (htail.S_ref / (pi * aero.e.htail * htail.AR * wing.S_ref));

end

aero.CD_trim = CD_trim;
aero.CL_htail = CL_tail;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIM DRAG CALCULATIONS IF CL_T IS STILL TOO BIG %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% CL_tail = [0.9 1 0.6 0.7 0.72 0.78 0.2]; % MADE UP
% 
% CD_trim = CL_tail.^2 * (htail.S_ref / (pi * aero.e.htail * htail.AR * wing.S_ref));
% 
% aero.CD_trim = CD_trim;
% aero.CL_htail = CL_tail;

%% TODO FINISH

%{
% For horizontal tail
AR_htail = aircraft.geometry.htail.AR;

x   = 6.4337; % [m] WHAT IS THIS? PARAMETRIZE TODO
x_w = 1.8652; % [m] WHAT IS THIS? PARAMETRIZE TODO

MAC_HT = aircraft.geometry.htail.MAC; % [m]
S_HT   = aircraft.geometry.htail.S_ref; % [m^2]
V_HT   = aircraft.geometry.htail.volume_coefficient; 

CL_wing_clean   = aero.CL.clean; % NEED TO UPDATE ONCE VALUE IS DONE
CL_wing_takeoff = aero.CL.takeoff_flaps_slats; % NEED TO UPDATE ONCE VALUE IS DONE
CL_wing_landing = aero.CL.landing_flaps_slats; % NEED TO UPDATE ONCE VALUE IS DONE

%% CMac WING

%% TODO MAKE DIFFERENT FOR EACH CONFIG and PARAMETRIZE

Cl = 2 * pi * 10 * (pi/180); % [rad] GET ACTUAL DISTRIBUTION, FOR DIFFERENT CONFIGS??
c  = @(y) 4.187 - (0.628*y); % PARAMETRIZE W/ TAPER RATIO
x_ac = NaN; % before it was 2.2218; %TODO WHAT IS THIS?

b_wing = aircraft.geometry.wing.b; % [m]

CM_ac  = 0.524; % NEEDS TO BE UPDATED

function1 = @(y)(Cl * c(y) * x_ac);
function2 = @(y)(CM_ac * c(y).^2);

int1 = integral(function1, -b_wing/2, b_wing/2);
int2 = integral(function2, -b_wing/2, b_wing/2);

CM_ac_w = (1 / MAC_tail * S_ref_wing) * (-int1 + int2);

%% CMac DELTA FLAPS

%? this is accounted for above if we make it different?

%% CMac FUSELAGE TODO FIX AND PARAMETRIze

pitching_moment_factor = 0.6133;
width_fus = 2.1; % [m]

MAC_wing = aircraft.geometry.wing.MAC;
alpha_fus = 10; % [degrees] Estimated

CM_fus = ((pitching_moment_factor * width_fus^2 * l_fuselage) / (MAC_wing * S_ref_wing)) * alpha_fus;

%% TOTAL

CM_pitch_minus_tail_clean   = CM_ac_w + CM_fus; % + delta_CM_ac_flap THIS WILL CHANGE TODO FIX
CM_pitch_minus_tail_takeoff = CM_ac_w + CM_fus; % + delta_CM_ac_flap THIS WILL CHANGE
CM_pitch_minus_tail_landing = CM_ac_w + CM_fus; % + delta_CM_ac_flap THIS WILL CHANGE

CLt_clean   = (CL_wing_clean   * (x_w/MAC_HT) + CM_pitch_minus_tail_clean)   * (x / (x-x_w)) * (1 / V_HT);
CLt_takeoff = (CL_wing_takeoff * (x_w/MAC_HT) + CM_pitch_minus_tail_takeoff) * (x / (x-x_w)) * (1 / V_HT);
CLt_landing = (CL_wing_landing * (x_w/MAC_HT) + CM_pitch_minus_tail_landing) * (x / (x-x_w)) * (1 / V_HT);

aero.CD_trim.clean         = (CLt_clean^2   / ( pi * aero.e.htail * AR_htail) ) * (S_HT / S_ref_wing); 
aero.CD_trim.takeoff_flaps = (CLt_takeoff^2 / ( pi * aero.e.htail * AR_htail) ) * (S_HT / S_ref_wing);
aero.CD_trim.landing_flaps = (CLt_landing^2 / ( pi * aero.e.htail * AR_htail) ) * (S_HT / S_ref_wing);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WAVE DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TODO FINISH
%{
k             = 0.95; % for transonic airfoils
sweep_QC_wing = aircraft.geometry.wing.sweep_QC_wing;
t_c           = aircraft.geometry.wing.t_c;
CL_cruise     = aircraft.aerodynamics.CL.cruise;

aircraft.aerodynamics.MDD = k / cos(sweep_QC_wing) - t_c / cos(sweep_QC_wing)^2 - CL_cruise / (10 * cos(sweep_QC_wing)^3);
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TOTAL DRAG COEFFICIENT %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% TODO ADD WAVE, TRIM DRAG. These are calculated for a variety of Mach numbers. find out how to integrate that array
aero.CD.clean = aero.CD0.clean + aero.CDi.cruise + aero.CD_trim(4); %+ aero.CD_wave.cruise;

aero.CD.takeoff_flaps_slats      = aero.CD0.takeoff_flaps_slats      + aero.CDi.takeoff_flaps_slats + aero.CD_trim(1);
aero.CD.takeoff_flaps_slats_gear = aero.CD0.takeoff_flaps_slats_gear + aero.CDi.takeoff_flaps_slats + aero.CD_trim(1);

aero.CD.landing_flaps_slats      = aero.CD0.landing_flaps_slats      + aero.CDi.landing_flaps_slats + aero.CD_trim(2);
aero.CD.landing_flaps_slats_gear = aero.CD0.landing_flaps_slats_gear + aero.CDi.landing_flaps_slats + aero.CD_trim(2);

%% REASSIGN %%

aircraft.aerodynamics = aero;
aircraft.geometry.htail = htail;

