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

%% Initial wing parameters %%

aircraft.geometry.S_wet_regression_calc = @(W0) ConvArea( 10^(-0.1289)*(ConvMass(W0,'kg','lbm'))^0.7506, 'ft2','m2'); 
aircraft.geometry.length_regression_calc = @(W0) 0.389*W0^0.39; % this is a historical regression from Raymer table 6.3

aircraft.geometry.wing.AR = 3.6; %From trade studies

wing = aircraft.geometry.wing;

wing.sweep_LE = deg2rad(44.9); %radians
wing.S_ref = 25.25;

wing.S_flapped = 10.588*2; % TODO UPDATE
wing.S_slatted = 10.588*2; % TODO UPDATE

% Area ratios THAT THE ABOVE VALUES MUST AT LEAST MEET
flapped_ratio = 0.8643; %S_flapped / S_ref; % max ratio approximated
slatted_ratio = 0.8643; %S_slatted / S_ref;

wing.sweep_flap_hinge = 0;
wing.sweep_slat_hinge = wing.sweep_LE; % [rad]

wing.c_flapped_over_c = 0.3; % ratio of flapped chord to chord
wing.c_slatted_over_c = 0.1; % TODO Verify/update

wing.flap_deflect_takeoff = deg2rad(15);
wing.flap_deflect_landing = deg2rad(30);
wing.slat_deflect_takeoff = deg2rad(7);
wing.slat_deflect_landing = deg2rad(16);

aircraft.geometry.wing = wing;

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

%% Calculate change in wing CL

aircraft.aerodynamics.CL.takeoff_clean = 0.9 * sectional_clean_Cl;
base_CL_w = aircraft.aerodynamics.CL.takeoff_clean;

aircraft.aerodynamics.CL.cruise = 0.9 * sectional_cruise_Cl;

% Take Off TODO include which raymer eq this was pulled from

del_CL_wing_TO_slat = 0.9 * del_Cl_TO_slat * slatted_ratio * cos(wing.sweep_slat_hinge);
del_CL_wing_TO_flap = 0.9 * del_Cl_TO_flap * flapped_ratio * cos(wing.sweep_flap_hinge);

aircraft.aerodynamics.CL.takeoff_flaps_slats = base_CL_w + del_CL_wing_TO_slat + del_CL_wing_TO_flap;

% Landing

del_CL_wing_L_slat = 0.9 * del_Cl_L_slat * slatted_ratio * cos(wing.sweep_slat_hinge);
del_CL_wing_L_flap = 0.9 * del_Cl_L_flap * flapped_ratio * cos(wing.sweep_flap_hinge);

aircraft.aerodynamics.CL.landing_flaps_slats = base_CL_w + del_CL_wing_L_slat + del_CL_wing_L_flap;

end