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

% For all aircraft aspects - Given in table in drive under utilities
S_ref_wing = wing.S_ref; % [m^2]

wing_airfoil_mach = [0.20 0.40 0.60 0.65 0.70 ...
                     0.75 0.80 0.90 1.00 1.05 ...
                     1.10 1.13];

aero.drag_freesteam_mach = wing_airfoil_mach/cos(aircraft.geometry.wing.sweep_LE);

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

aero.e.htail = 1.78 * (1 - (0.045 * aircraft.geometry.htail.AR^0.68) ) - 0.64; % from the presentation slide 26

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIFT INDUCED DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AR_wing = aircraft.geometry.wing.AR;

aero.CDi.clean         = aero.CL.clean^2         / (pi * AR_wing * aero.e.clean);
aero.CDi.takeoff_flaps = aero.CL.takeoff_flaps^2 / (pi * AR_wing * aero.e.takeoff_flaps);
aero.CDi.landing_flaps = aero.CL.landing_flaps^2 / (pi * AR_wing * aero.e.landing_flaps);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TRIM DRAG CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
CL_wing_takeoff = aero.CL.takeoff_flaps; % NEED TO UPDATE ONCE VALUE IS DONE
CL_wing_landing = aero.CL.landing_flaps; % NEED TO UPDATE ONCE VALUE IS DONE

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

%% TODO ADD WAVE, TRIM DRAG
aero.CD.clean = aero.CD0.clean + aero.CDi.clean + CD_trim;

aero.CD.takeoff_flaps      = aero.CD0.takeoff_flaps      + aero.CDi.takeoff_flaps + aero.CD_trim.takeoff_flaps;
aero.CD.takeoff_flaps_gear = aero.CD0.takeoff_flaps_gear + aero.CDi.takeoff_flaps + aero.CD_trim.takeoff_flaps;

aero.CD.landing_flaps      = aero.CD0.landing_flaps      + aero.CDi.landing_flaps + aero.CD_trim.landing_flaps;
aero.CD.landing_flaps_gear = aero.CD0.landing_flaps_gear + aero.CDi.landing_flaps + aero.CD_trim.landing_flaps;

%% REASSIGN %%

aircraft.aerodynamics = aero;