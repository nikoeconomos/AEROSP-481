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

aircraft = generate_target_CL_params(aircraft);

wing = aircraft.geometry.wing;
aero = aircraft.aerodynamics;

% For all aircraft aspects - Given in table in drive under utilities
S_ref_wing = wing.S_ref; % [m^2]

wing_airfoil_mach = [0.20 0.40 0.60 0.65 0.70 ...
                     0.75 0.80 0.90 1.00 1.05 ...
                     1.10 1.13];

freesteam_mach  = wing_airfoil_mach/cos(aircraft.geometry.wing.sweep_LE);

Cf_turbulent_calc = @(Re) 0.455 ./ ((log10(Re)).^2.58 * (1 + 0.144 * freesteam_mach.^2)^0.65); % turbulent

%%%%%%%%%%%%%%%%%%%%%%
%% CD0 CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%

%% Fuselage %%

% Aircraft parameters
l_fuselage     = aircraft.geometry.fuselage.length;
S_wet_fuselage  = aircraft.geometry.fuselage.S_wet; % [m^2]
A_max_fuselage = aircraft.geometry.fuselage.A_max; % Estimated cross-sectional area

Q_fuselage     = 1; % Interference factor, given on slide 16 of lecture 14

Re_fuselage = speed_of_sound .* wing_airfoil_mach .* l_fuselage ./ kinematic_viscosities;
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

% Inlet parameters
l_inlet     = aircraft.geometry.inlet.length; % [m]
S_wet_inlet  = aircraft.geometry.inlet.S_wet; % [m^2], Estimated
A_max_inlet = aircraft.geometry.inlet.length;

Q_inlet = 1; % Assumed 1

Re_inlet = Re_fuselage * (l_inlet / l_fuselage); 

Cf_inlet = Cf_turbulent_calc(Re_inlet);

% Form factor
f_inlet  = l_inlet / sqrt(4 * pi * A_max_inlet); 
FF_inlet = 0.9 + (5 / (f_inlet^1.5)) + (f_inlet / 400); 

CD0_inlets = ((Cf_inlet * FF_inlet * Q_inlet * S_wet_inlet) / S_ref_wing) * 2; % Two inlets, multiply by two

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

FF_wing = (1 + (0.6 / (loc_max_thickness_wing)) * (t_c_wing) + 100 * (t_c_wing)^4) * (1.34 * freesteam_mach.^0.18 * cos(sweep_HC_wing)^0.28);

CD0_wing = (Cf_wing * FF_wing * Q_wing * S_wet_wing) / S_ref_wing;

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

FF_htail = (1 + (0.6 / (loc_max_thickness_htail)) * (t_c_htail) + 100 * (t_c_htail)^4) * (1.34 * freesteam_mach.^0.18 * cos(sweep_HC_htail)^0.28);

CD0_htail = (Cf_htail * FF_htail * Q_htail * S_wet_htail) / S_ref_wing;

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

FF_vtail = (1 + (0.6 / (loc_max_thickness_vtail)) * (t_c_vtail) + 100 * (t_c_vtail)^4) * (1.34 * freesteam_mach.^0.18 * cos(sweep_HC_vtail)^0.28);

CD0_vtail = (Cf_vtail * FF_vtail * Q_vtail * S_wet_vtail) / S_ref_wing;

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

delta_CD0_takeoff_flaps = F_flap * (cf_c) * (S_flapped / S_ref_wing) * (flap_deflect_takeoff - 10);
delta_CD0_landing_flaps = F_flap * (cf_c) * (S_flapped / S_ref_wing) * (flap_deflect_landing - 10);

%% Total Parasitic Drag Calc %%

CD0_component_sum  = CD0_fuselage + CD0_inlets + CD0_wing  + CD0_htail + CD0_vtail; 

aero.CD0.clean = CD0_component_sum + CD0_misc + CD0_lp; 

aero.CD0.takeoff_flaps      = aero.CD0.clean + delta_CD0_takeoff_flaps;
aero.CD0.takeoff_flaps_gear = aero.CD0.takeoff_flaps + CD0_lg;

aero.CD0.landing_flaps = aero.CD0.clean + delta_CD0_landing_flaps;
aero.CD0.landing_flaps_gear = aero.CD0.landing_flaps + CD0_lg;

%%%%%%%%%%%%%%%%%%%%%%%%
%% CALCULATE e VALUES %%
%%%%%%%%%%%%%%%%%%%%%%%%

aero.e.clean         = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.clean, 0, 0.98);
aero.e.takeoff_flaps = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.takeoff_flaps, 0, 0.98);
aero.e.landing_flaps = oswaldfactor(aircraft.geometry.wing.AR, aircraft.geometry.wing.sweep_LE,'shevell', aero.CD0.landing_flaps, 0, 0.98);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIFT INDUCED DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


AR = aircraft.geometry.wing.AR;

aero.CDi.clean         = aero.CL.clean         / (pi * AR * aero.e.clean);
aero.CDi.takeoff_flaps = aero.CL.takeoff_flaps / (pi * AR * aero.e.takeoff_flaps);
aero.CDi.landing_flaps = aero.CL.landing_flaps / (pi * AR * aero.e.landing_flaps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIM DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For horizontal tail
aspect_ratio_t = 7.984;
et = 1.78 * (1 - (0.045 * aspect_ratio_t^0.68)) - 0.64;
x = 6.4337; % [m]
MAC_tail = 0.9921; % [m]
S_tail = 3.667 * 2; % [m^2]
tail_volume_coeff = (x * S_tail) / (MAC_tail * S_ref_wing); 
CL_wing = 0.6; % NEED TO UPDATE ONCE VALUE IS DONE
xw = 1.8652; % [m]

pitching_moment_factor = 0.6133;
width_fus = 2.1; % [m]
MAC = 3.0446;
alpha_fus = 10; % [degrees] Estimated
CM_fus = ((pitching_moment_factor * width_fus^2 * l_fuselage) / (MAC * S_ref_wing)) * alpha_fus;
x_ac = 2.2218; % [m]

% delta_CM_ac_flap = ;

Cl = 2 * pi * 10 * (pi/180); % [rad] Estimated
c = @(x)4.187 - (0.628*x);
span = 8.67; % [m]
CM_ac = 0.524; % NEEDS TO BE UPDATED
function1 = @(x)(Cl * c(x) * x_ac);
function2 = @(x)(CM_ac * c(x).^2);
int1 = integral(function1, -span/2, span/2);
int2 = integral(function2, -span/2, span/2);
CM_ac_w = (1 / MAC_tail * S_ref_wing) * (-int1 + int2);

CM_pitch_minus_tail = CM_ac_w + CM_fus; % + delta_CM_ac_flap

CLt = (CL_wing * (xw/MAC_tail) + CM_pitch_minus_tail) * (x / (x-xw)) * (1 / tail_volume_coeff); 

CD_trim = (CLt^2 / pi * et * aspect_ratio_t) * (S_tail / S_ref_wing); 
disp(['The total trim drag (CD_trim) is ', num2str(CD_trim)])

%% Total Drag Coefficent %%

CD_total = CD0_total + delta_CD0_flap + CD_i + CD_trim;
disp(['The total drag coefficent (CD_total) is ', num2str(CD_total)])
