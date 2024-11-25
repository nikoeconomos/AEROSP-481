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

aircraft = generate_target_CL_values(aircraft);

wing = aircraft.geometry.wing;

% For all aircraft aspects - Given in table in drive under utilities
S_ref_w = wing.S_ref; % [m^2]

Mach_numbers = [0.282, 0.565, 0.847, 0.918, 0.988, 1.059, 1.129, 1.271, 1.412, 1.482, 1.553, 1.595, 1.6];

wing_airfoil_mach = [0.20 0.40 0.60 0.65 0.70 ...
                     0.75 0.80 0.90 1.00 1.05 ...
                     1.10 1.13 1.20];

freesteam_mach  = airfoil_mach/cos(aircraft.geometry.wing.sweep_LE);

ht_airfoil_mach = freesteam_mach*cos(aircraft.geometry.wing.sweep_LE);

alt_cruise = aircraft.performance.cruise_alt;
alt_climb  = 6000;
altitude   = [0, alt_climb, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise, alt_cruise];

[~, ~, rho_SL, a_SL]         = standard_atmosphere_calc(0);
[~, ~, rho_climb, a_climb]   = standard_atmosphere_calc(alt_climb);
[~, ~, rho_cruise, a_cruise] = standard_atmosphere_calc(alt_cruise);
rho            = [rho_SL, rho_climb, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise, rho_cruise];

nu_SL     = 0.00001461;
nu_6000   = 0.00002416;
nu_cruise = 0.00003706;
kinematic_viscosity = [nu_SL, nu_6000, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise, nu_cruise];
dynamic_viscosity   = kinematic_viscosity * rho;

speed_of_sound  = [a_SL, a_climb, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise, a_cruise];
flight_velocity = freestream_mach.*speed_of_sound;

Cf_turbulent_calc = @(Re) 0.455 ./ ((log10(Re)).^2.58 * (1 + 0.144 * freesteam_mach.^2)^0.65); % turbulent

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

CD0_fuselage_arr = ((Cf_fuselage .* FF_fuselage .* Q_fuselage .* S_wet_fuselage) / S_ref_w);

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

CD0_inlets = ((Cf_inlet * FF_inlet * Q_inlet * S_wet_inlet) / S_ref_w) * 2; % Two inlets, multiply by two

%% Wings (Both) %%

% Wing parameters
S_wet_wing = aircraft.geometry.wing.S_wet; % [m^2]
Q_wings = 1; % Assumed 1 for a mid-wing configuration
loc_max_thickness = 0.386; % [m]
thickness_to_chord = 0.06; % Average is 6%
sweep = 37.04; % [degrees] Sweep angle of max thickness line
c_wing = 4.187; % [m] at root

CD0_wings_array = zeros(size(Mach_numbers)); 

for i = 1:length(Mach_numbers)

    % Flight conditions
    M = Mach_numbers(i);
    Re_wings = Re_fuselage_values(i) * (c_wing / l_fuselage);
    V = Mach_numbers(i) * speed_of_sound(i);
    x_laminar_wings = 0.3; % Estimated

    % Skin friction coefficients
    Cf_wings_laminar = 1.328 / sqrt(Re_wings);
    Cf_wings_turbulent = 0.455 / ((log10(Re_wings))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_wings_effective = x_laminar_wings * Cf_wings_laminar + (1 - x_laminar_wings) * Cf_wings_turbulent;

    % Form factor 
    FF_wings = (1 + (0.6 / (loc_max_thickness)) * (thickness_to_chord) + 100 * (thickness_to_chord)^4) * (1.34 * Mach_numbers(i).^(0.18) * cos(sweep)^0.28);

    CD0_wings = ((Cf_wings_effective * FF_wings * Q_wings * Swet_wings) / S_ref_w);

    CD0_wings_array(i) = CD0_wings;
end

%% Nose (Needle) %%

% Needle parameters
Swet_needle = 0.509; % [m^2]
l_needle = 1.41; % [m]
Q_needle = 1; % Assumed 1

CD0_needle_array = zeros(size(Mach_numbers)); 

for i = 1:length(Mach_numbers)

    % Flight conditions
    M = Mach_numbers(i);
    Re_needle = Re_fuselage_values(i) * (l_needle / l_fuselage); 
    V = Mach_numbers(i) * speed_of_sound(i); 
    x_laminar_needle = 0.8; % Assumed higher due to streamlined shape

    % Skin friction coefficients
    Cf_needle_laminar = 1.328 / sqrt(Re_needle);
    Cf_needle_turbulent = 0.455 / ((log10(Re_needle))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_needle_effective = x_laminar_needle * Cf_needle_laminar + (1 - x_laminar_needle) * Cf_needle_turbulent;

    % Form factor
    f_needle = l_needle / sqrt(4 * pi * (Swet_needle / (4 * pi))); 
    FF_needle = 1 + 0.35 / (f_needle^1.5); % Simplified form factor for a slender nose

    CD0_needle = ((Cf_needle_effective * FF_needle * Q_needle * Swet_needle) / S_ref_w);

    CD0_needle_array(i) = CD0_needle;
end

%% Horizontal Stabilizer (Both) %%

% Horizontal stabilizer parameters
Swet_HS = 7.35200; % [m^2]
c_HS = 1.276; % [m]
Q_HS = 1.0; % Assumed 1

CD0_HS_array = zeros(size(Mach_numbers));

for i = 1:length(Mach_numbers)

    % Flight conditions
    M = Mach_numbers(i);
    Re_HS = Re_fuselage_values(i) * (c_HS / l_fuselage);
    V = Mach_numbers(i) * speed_of_sound(i);
    x_laminar_HS = 0.3; % Estimated

    % Skin friction coefficients
    Cf_HS_laminar = 1.328 / sqrt(Re_HS);
    Cf_HS_turbulent = 0.455 / ((log10(Re_HS))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_HS_effective = x_laminar_HS * Cf_HS_laminar + (1 - x_laminar_HS) * Cf_HS_turbulent;

    % Form factor
    f_HS = c_HS / (2 * (Swet_HS / S_ref_w)^(1/2)); 
    FF_HS = 1 + 2.7 / f_HS + (f_HS / 400);

    CD0_HS = ((Cf_HS_effective * FF_HS * Q_HS * Swet_HS) / S_ref_w);

    CD0_HS_array(i) = CD0_HS;
end

%% Vertical Stabilizer (Both) %%

% Vertical stabilizer parameters
Swet_VS = 3.73; % [m^2]
c_VS = 1.381; % [m]
Q_VS = 1.08; % For an H-tail configuration

CD0_VS_array = zeros(size(Mach_numbers)); 

for i = 1:length(Mach_numbers)
    % Flight conditions
    M = Mach_numbers(i);
    Re_VS = Re_fuselage_values(i) * (c_VS / l_fuselage); 
    V = Mach_numbers(i) * speed_of_sound(i); 
    x_laminar_VS = 0.3; % Estimated

    % Skin friction coefficients
    Cf_VS_laminar = 1.328 / sqrt(Re_VS);
    Cf_VS_turbulent = 0.455 / ((log10(Re_VS))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_VS_effective = x_laminar_VS * Cf_VS_laminar + (1 - x_laminar_VS) * Cf_VS_turbulent;

    % Form factor
    f_VS = c_VS / (2 * (Swet_VS / S_ref_w)^(1/2));
    FF_VS = 1 + 2.7 / f_VS + (f_VS / 400); 

    CD0_VS = ((Cf_VS_effective * FF_VS * Q_VS * Swet_VS) / S_ref_w);

    CD0_VS_array(i) = CD0_VS;
end

%% Miscellaneous Drag %%

CD_misc = 0; % Assumed to be zero because no main sources apply to our aircraft

%% Leakage and Protuberance Drag %%

CD_lp = 0.02; % Estimated from table in slides

%% Total Parasitic Drag Calc %%

total_components_CD0 = CD0_fuselage + CD0_inlets + CD0_wings + CD0_needle + CD0_HS + CD0_VS; 
CD0 = (1/S_ref_w) * (total_components_CD0) + CD_misc + CD_lp; 
CD0_total = CD0;
disp(['The total parasitic drag (CD) is ', num2str(CD0)]) % Used to ensure CD0 looks reasonable

%% Flap Drag %%

F_flap = 0.0144; % Given value for plain flaps
Cf = 0.325; % [m]
C_wing_at_flap = 1.375; % [m] Outboard
S_flapped = 11.611; % [m^2]
delta_flap = 40; % From raymer, between 40-45 degrees for max lift

delta_CD0_flap = F_flap * (Cf / C_wing_at_flap) * (S_flapped / S_ref_w) * (delta_flap - 10);
disp(['The delta flap drag (delta_CD_flap) is ', num2str(delta_CD0_flap)])

%% Lift Induced Drag %%

CL = 1.25; % Max CL
aspect_ratio = 3.068;
e = 0.68; % Estimated

CD_i = CL^2 / pi * aspect_ratio * e;
disp(['The total lift induced drag (CD_i) is ', num2str(CD_i)])

%% Trim Drag %%

% For horizontal tail
aspect_ratio_t = 7.984;
et = 1.78 * (1 - (0.045 * aspect_ratio_t^0.68)) - 0.64;
x = 6.4337; % [m]
MAC_tail = 0.9921; % [m]
S_tail = 3.667 * 2; % [m^2]
tail_volume_coeff = (x * S_tail) / (MAC_tail * S_ref_w); 
CL_wing = 0.6; % NEED TO UPDATE ONCE VALUE IS DONE
xw = 1.8652; % [m]

pitching_moment_factor = 0.6133;
width_fus = 2.1; % [m]
MAC = 3.0446;
alpha_fus = 10; % [degrees] Estimated
CM_fus = ((pitching_moment_factor * width_fus^2 * l_fuselage) / (MAC * S_ref_w)) * alpha_fus;
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
CM_ac_w = (1 / MAC_tail * S_ref_w) * (-int1 + int2);

CM_pitch_minus_tail = CM_ac_w + CM_fus; % + delta_CM_ac_flap

CLt = (CL_wing * (xw/MAC_tail) + CM_pitch_minus_tail) * (x / (x-xw)) * (1 / tail_volume_coeff); 

CD_trim = (CLt^2 / pi * et * aspect_ratio_t) * (S_tail / S_ref_w); 
disp(['The total trim drag (CD_trim) is ', num2str(CD_trim)])

%% Total Drag Coefficent %%

CD_total = CD0_total + delta_CD0_flap + CD_i + CD_trim;
disp(['The total drag coefficent (CD_total) is ', num2str(CD_total)])
