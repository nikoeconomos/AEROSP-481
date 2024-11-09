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
% Author:                          Juan and Victoria
% Version history revision notes:
%                                  v1: 11/8/2024

% Need to calculate drag at each component, then add together for total
% drag

Sref = 24.5; %[meters^2]

%% Fuselage %%
l_fuselage = 15.59; % [meters]
rho = 
V =
mu = 
M =
A_max =

% Go over multiple Reynold's numbers for different flight conditions
% Look at utilities in the drive
Re_fuselage = (rho * V * l_fuselage) / mu;
Cf_fuselage_laminar = 1.328 / sqrt(Re_fuselage);
Cf_fuselage_turbulent = 0.455 / ((log(Re_fuselage))^2.58 * (1+0.144*M^2)^0.65);

% Different equations for different parts of teh plane
FF_fuselage = 0.9 + (5/(f^1.5)) + (f/400);
f = l_fuselage / sqrt(4*pi*A_max);

% Given on slide 16 of lecture 14
Q_fuselage = 1;

% In Weights and Balnce Doc in drive
Swet_fuselage = 81.3657; %[meters^2]

CD_misc_fuselage =
CD_lp_fuselage =

CD0_fuselage = (Cf_fuselage * FF_fuselage * Q_fuselage * Swet_fuselage) + CDmisc_fuselage + CDlp_fuselage; % From Lecture 14 slides

%% Inlets %%

% Estimated 
Swet_inlets = 8.562 * 1.5; %[meters^2]

%% Wings %%
% Asking for both wings

Swet_wings = 48.514; %[meters^2]

%% Nose (Needle) %%
Swet_needle = 0.509; %[meters^2]

%% Horizontal Stabilizer %%
% Asking for both

Swet_HS = 2*(3.667+0.009); %[meters^2]

%% Vertical Stabilizer %%
% Asking for both

Swet_VS = 2*(1.484+(2*0.129)+0.123); %[meters^2]

%% Avionics Bump %%

% Estimated
Swet_AB = 0.702/20; %[meters^2]

%% Total Parasitic Drag Calc %%

CD0 = (1/S_ref) * (CD0_fuselage + CD0_inlets + CD0_wings + CD0_needle + CD0_HS + CD0_VS + CD0_AB);
CD0_total = CD0;




%% Total Drag Coefficent %%
CD_total = CD0_total + delta_CD_flaps + CD_i + CD_trim;
