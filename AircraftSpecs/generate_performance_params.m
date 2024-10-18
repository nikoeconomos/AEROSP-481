% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_performance_params()
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

%%

aircraft.performance.TW_design = 0.85; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM [N/N]
aircraft.performance.WS_design = 475; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM, [N/m^2]

%% MOSTLY FROM RFP %%



% loads
aircraft.performance.load_factor_upper_limit = 7; % [g's] with 50% fuel
aircraft.performance.load_factor_lower_limit = -3; % [g's]  with 50% fuel
aircraft.performance.dynamic_pressure_load = 102128.48; %[Pa], 2133 psf in rfp

% altitude
aircraft.performance.cruise_alt = 10668; % [m]

% mach numbers
aircraft.performance.cruise_mach = 0.85; % TODO UPDATE --> estimate from online
aircraft.performance.dash_mach = 1.6; % from rfp
aircraft.performance.mach_max_alt = 1.6; %[Mach number], at 35000 feet
aircraft.performance.endurance_mach = 0.4; % estimate from online

aircraft.performance.max_sustained_turn_mach = 1.2; %[Mach] from RFP
aircraft.performance.min_sustained_turn_mach = 0.9; %[Mach] from RFP

% misc
aircraft.performance.bank_angle_360 = 60; %[Deg] ESTIMATE FROM ONLINE

aircraft.safety_factor = 1.5;

aircraft.service_life = 2000; %[hours]

end