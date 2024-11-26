function [aircraft] = generate_CL_params(aircraft)
% Description: 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    plugs in Cl max values and gets CL for different conditions                   
% 
% See also:
% Author:                          Juan
% Version history revision notes:
%                                  v1: 11/24/2024


%% Define constant parameters

sectional_clean_Cl  = 0.5248542; % From simulation at AOA = 2, takeoff speed

sectional_cruise_Cl = 0.6305; % From simulation at AOA = 2, cruise

% From simulation at AOA = 6
sectional_slat_TO_Cl = 0.88913;
sectional_flap_TO_Cl = 1.36804;

% From simulation at AOA = 10
sectional_slat_L_Cl = 1.460362;
sectional_flap_L_Cl = 1.729245;

del_Cl_TO_slat = abs(sectional_clean_Cl - sectional_slat_TO_Cl);
del_Cl_TO_flap = abs(sectional_clean_Cl - sectional_flap_TO_Cl);

del_Cl_L_slat = abs(sectional_clean_Cl - sectional_slat_L_Cl);
del_Cl_L_flap = abs(sectional_clean_Cl - sectional_flap_L_Cl);

% From CAD
S_flapped = aircraft.geometry.wing.S_flapped;
S_slatted = aircraft.geometry.wing.S_slatted; %Currently 21.176

S_ref = aircraft.geometry.wing.S_ref;

sweep_slat_hinge = deg2rad(aircraft.geometry.wing.sweep_LE); % [rad]
sweep_flap_hinge = deg2rad(aircraft.geometry.wing.sweep_flap_hinge); % [rad]

% Area ratios
flapped_ratio = S_flapped / S_ref;
slatted_ratio = S_slatted / S_ref;

%% Calculate change in wing CL

aircraft.aerodynamics.CL.clean_wing_low_speed = 0.9 * sectional_clean_Cl;

aircraft.aerodynamics.CL.cruise = 0.9 * sectional_cruise_Cl;

base_CL_w = aircraft.aerodynamics.CL.clean_wing_low_speed;

% Take Off

del_CL_wing_TO_slat = 0.9 * del_Cl_TO_slat * slatted_ratio * cos(sweep_slat_hinge);
del_CL_wing_TO_flap = 0.9 * del_Cl_TO_flap * flapped_ratio * cos(sweep_flap_hinge);

aircraft.aerodynamics.CL.takeoff_flaps_slats = base_CL_w + del_CL_wing_TO_slat + del_CL_wing_TO_flap;

% Landing

del_CL_wing_L_slat = 0.9 * del_Cl_L_slat * slatted_ratio * cos(sweep_slat_hinge);
del_CL_wing_L_flap = 0.9 * del_Cl_L_slat * flapped_ratio * cos(sweep_flap_hinge);

aircraft.aerodynamics.CL.landing_flaps_slats = base_CL_w + del_CL_wing_L_slat + del_CL_wing_L_flap;

end