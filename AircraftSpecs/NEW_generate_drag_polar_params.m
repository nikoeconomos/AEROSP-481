% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_drag_polar_params(aircraft)
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

% For all aircraft aspects

Sref = 24.5; % [m^2]

%% Fuselage %%

% Flight conditions from table in drive under utilities
Mach_numbers = [0.282, 0.565, 0.847, 0.918, 0.988, 1.059, 1.129, 1.271, 1.412, 1.482, 1.553, 1.595, 1.694];
altitudes = [0, 6000, 10600, 10600, 10600, 10600, 10600, 10600, 10600, 10600, 10600, 10600, 10600];
kinematic_viscosities = [0.00001461, 0.00002416, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706, 0.00003706];
speed_of_sound = [340.3, 316.5, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4, 297.4];
Re_fuselage_values = [72630000, 81690000, 75060000, 81320000, 87570000, 93830000, 100090000, 112600000, 125110000, 131360000, 137620000, 141370000, 150130000];

% Aircraft parameters
l_fuselage = 15.59; % [m]
Swet_fuselage = 81.3657; % [m^2]
A_max = pi * (l_fuselage / 4)^2; % Estimated cross-sectional area
CD_misc_fuselage = 0.002; % Assumed value
CD_lp_fuselage = 0.001; % Assumed value
Q_fuselage = 1; % Interference factor, given on slide 16 of lecture 14
rho = 1.225; % Sea level density

CD0_fuselage_array = zeros(size(Mach_numbers));

for i = 1:length(Mach_numbers)
    
    % Flight conditions
    M = Mach_numbers(i);
    Re_fuselage = Re_fuselage_values(i);
    V = Mach_numbers(i) * speed_of_sound(i); % Compute velocity
    mu = kinematic_viscosities(i) * rho; % Dynamic viscosity
    x_laminar = 0.3; % Estimated

    % Skin friction coefficients - from slides
    Cf_fuselage_laminar = 1.328 / sqrt(Re_fuselage);
    Cf_fuselage_turbulent = 0.455 / ((log10(Re_fuselage))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_fuselage_effective = x_laminar * Cf_fuselage_laminar + (1 - x_laminar) * Cf_fuselage_turbulent;

    % Fineness ratio and form factor for fuselage
    f = l_fuselage / sqrt(4 * pi * A_max);
    FF_fuselage = 0.9 + (5 / (f^1.5)) + (f / 400);

    CD0_fuselage = (Cf_fuselage_effective * FF_fuselage * Q_fuselage * Swet_fuselage / Sref) + CD_misc_fuselage + CD_lp_fuselage;
    
    CD0_fuselage_array(i) = CD0_fuselage;
end

%% Inlets %%

% Inlet parameters
Swet_inlets = 8.562 * 1.5; % [m^2], Estimated
l_inlets = 1.0; % [m]
CD_misc_inlets = 0.001; % Estimated
CD_lp_inlets = 0.0005; % Estimated
Q_inlets = 1; % Assumed 1 because 1 means negligible effects

CD0_inlets_array = zeros(size(Mach_numbers));

for i = 1:length(Mach_numbers)
    
    % Flight conditions
    M = Mach_numbers(i);
    Re_inlets = Re_fuselage_values(i) * (l_inlets / l_fuselage); 
    V = Mach_numbers(i) * speed_of_sound(i); 
    x_laminar_inlets = 0.3; % Estimated

    % Skin friction coefficients
    Cf_inlets_laminar = 1.328 / sqrt(Re_inlets);
    Cf_inlets_turbulent = 0.455 / ((log10(Re_inlets))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_inlets_effective = x_laminar_inlets * Cf_inlets_laminar + (1 - x_laminar_inlets) * Cf_inlets_turbulent;

    % Form factor
    f_inlets = l_inlets / sqrt(4 * pi * (Swet_inlets / (4 * pi))); 
    FF_inlets = 1 + 1.5 / (f_inlets^1.5) + (f_inlets / 400);

    CD0_inlets = (Cf_inlets_effective * FF_inlets * Q_inlets * Swet_inlets / Sref) + CD_misc_inlets + CD_lp_inlets;

    CD0_inlets_array(i) = CD0_inlets;
end

%% Wings (Both) %%

% Wing parameters
Swet_wings = 48.514; % [m^2]
CD_misc_wings = 0.002; % Assumed
CD_lp_wings = 0.001; % Assumed
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

    CD0_wings = (Cf_wings_effective * FF_wings * Q_wings * Swet_wings / Sref) + CD_misc_wings + CD_lp_wings;

    CD0_wings_array(i) = CD0_wings;
end

%% Nose (Needle) %%

% Needle parameters
Swet_needle = 0.509; % [m^2]
l_needle = 1.41; % [m]
CD_misc_needle = 0.0003; % Estimated
CD_lp_needle = 0.0001; % Estimated
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

    CD0_needle = (Cf_needle_effective * FF_needle * Q_needle * Swet_needle / Sref) + CD_misc_needle + CD_lp_needle;

    CD0_needle_array(i) = CD0_needle;
end

%% Horizontal Stabilizer (Both) %%

% Horizontal stabilizer parameters
Swet_HS = 7.35200; % [m^2]
c_HS = 1.276; % [m]
CD_misc_HS = 0.0005; % Estimated
CD_lp_HS = 0.0002; % Estimated
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
    f_HS = c_HS / (2 * (Swet_HS / Sref)^(1/2)); 
    FF_HS = 1 + 2.7 / f_HS + (f_HS / 400);

    CD0_HS = (Cf_HS_effective * FF_HS * Q_HS * Swet_HS / Sref) + CD_misc_HS + CD_lp_HS;

    CD0_HS_array(i) = CD0_HS;
end

%% Vertical Stabilizer (Both) %%

% Vertical stabilizer parameters
Swet_VS = 3.73; % [m^2]
c_VS = 1.381; % [m]
CD_misc_VS = 0.0004; % Estimated
CD_lp_VS = 0.00015; % Estimated
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
    f_VS = c_VS / (2 * (Swet_VS / Sref)^(1/2));
    FF_VS = 1 + 2.7 / f_VS + (f_VS / 400); 

    CD0_VS = (Cf_VS_effective * FF_VS * Q_VS * Swet_VS / Sref) + CD_misc_VS + CD_lp_VS;

    CD0_VS_array(i) = CD0_VS;
end

%% Avionics Bump %%

%{
% Avionics bump parameters
Swet_AB = 0.0351; % [m^2]
c_AB = ; % NEED TO ADD
CD_misc_AB = 0.0002; % Estimated
CD_lp_AB = 0.00005; % Estimated
Q_AB = 1.0; % Assumed 1

CD0_AB_array = zeros(size(Mach_numbers)); 

for i = 1:length(Mach_numbers)

    % Flight conditions
    M = Mach_numbers(i);
    Re_AB = Re_fuselage_values(i) * (c_AB / l_fuselage); 
    V = Mach_numbers(i) * speed_of_sound(i); 
    x_laminar_AB = 0.3; % Estimated

    % Skin friction coefficients for the avionics bump
    Cf_AB_laminar = 1.328 / sqrt(Re_AB);
    Cf_AB_turbulent = 0.455 / ((log10(Re_AB))^2.58 * (1 + 0.144 * M^2)^0.65);
    Cf_AB_effective = x_laminar_AB * Cf_AB_laminar + (1 - x_laminar_AB) * Cf_AB_turbulent;
  
    % Form factor
    f_AB = c_AB / (2 * (Swet_AB / Sref)^(1/2)); 
    FF_AB = 1 + 2.7 / f_AB + (f_AB / 400); 

    CD0_AB = (Cf_AB_effective * FF_AB * Q_AB * Swet_AB / Sref) + CD_misc_AB + CD_lp_AB;

    CD0_AB_array(i) = CD0_AB;
end
%}

%% Total Parasitic Drag Calc %%

CD0 = (1/Sref) * (CD0_fuselage + CD0_inlets + CD0_wings + CD0_needle + CD0_HS + CD0_VS); % + CD0_AB from avionics bump
CD0_total = CD0;

%% Flap Drag %%

F_flap = 0.0144; % Given value for plain flaps
Cf = 0.325; % [m]
C_wing_at_flap = 1.375; % [m] Outboard
S_flapped = 11.611; % [m^2]
delta_flap = 40; % From raymer, between 40-45 degrees for max lift

delta_CD0_flap = F_flap * (Cf / C_wing_at_flap) * (S_flapped / Sref) * (delta_flap - 10);

%% Lift Induced Drag %%

CL = 1.25; % Max CL
aspect_ratio = 3.068;
e = 0.68; % Estimated

CD_i = CL^2 / pi * aspect_ratio * e;

%% Trim Drag %%

% For horizontal tail
aspect_ratio_t = 7.984;
et = 1.78 * (1 - 0.045 * aspect_ratio_t^0.68) - 0.64;
tail_volume_coeff = 0.135; % Calculated from drawing
MAC_tail = 0.9921; % [m]
x = 6.4337; % [m]
St = (tail_volume_coeff * MAC_tail * Sref) / x;
CL_wing = 0.6; % NEED TO UPDATE ONCE VALUE IS DONE
xw = 1.8652; % [m]

pitching_moment_factor = 0.6133;
width_fus = 2.1; % [m]
MAC = 3.0446;
alpha_fus = 10; % Estimated
CM_fus = ((pitching_moment_factor * width_fus^2 * l_fuselage) / (MAC * Sref)) * alpha_fus;
x_ac = 2.2218; % [m]

% delta_CM_ac_flap = ;

Cl = 2 * pi * 10 * (pi/180); % Estimated
c = @(x)4.187-0.628*x;
span = 8.67; % [m]
CM_ac = 0.524; % NEEDS TO BE UPDATED
function1 = @(x)(Cl * c(x) * x_ac);
function2 = @(x)(CM_ac * c(x).^2);
int1 = integral(function1, -span/2, span/2);
int2 = integral(function2, -span/2, span/2);
CM_ac_w = (1 / MAC_tail * Sref) * (-int1 + int2);

CM_pitch_minus_tail = CM_ac_w + CM_fus; % + delta_CM_ac_flap

CLt = (CL_wing * (xw/MAC_tail) + CM_pitch_minus_tail) * (x / (x-xw)) * (1 / tail_volume_coeff); 

CD_trim = (CLt^2 / pi * et * aspect_ratio_t) * (St / Sref); 

%% Total Drag Coefficent %%

CD_total = CD0_total + delta_CD0_flap + CD_i + CD_trim;
disp(CD_total) % Ideally should be less than 1
