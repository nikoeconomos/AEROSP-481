% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_RFP_params()
% Description: This function generates a struct that holds parameters used in
% calculating the initial weight estimate of our aircraft
% 
% 
% INPUTS:
% --------------------------------------------
%    None
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft -struct containing aircraft specifications given by RFP
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/10/2024
%                                  v1.1: 9/15/2024 - Added tentative
%                                  parameters based on the F100-PW-229.
%                                  (Joon)

%% PAYLOAD %%
%%%%%%%%%%%%%

% Number of missiles aboard the plane when taking off
aircraft.payload.num_missiles = 6; % [number]


%% PERFORMANCE %%
%%%%%%%%%%%%%%%%%

% max mach number at altitude
aircraft.performance.mach_max_alt = 1.6; %[Mach number], at 35000 feet

% max mach number at sea level
aircraft.performance.mach_max_SL = NaN; %[Mach number]

% g force limit, upper
aircraft.performance.g_force_upper_limit = 7; % [g's]

% g force limit, upper
aircraft.performance.g_force_lower_limit = -3; % [g's]    


%% %% %% %% UTILITY %% %% %% %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% miscelaneous constants for fluids/ performance calculations
aircraft.constants = generate_constants();

end