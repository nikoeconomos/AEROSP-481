% Aerosp 481 Group 3 - Libellula 
function aircraft = generate_prelim_sizing_params(aircraft)
% Description: This function generates a struct of aircraft parameters that
% relate to assignment 4, preliminary sizing.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with prelim sizing
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Hardcoded, climb values, guesses, etc %%
%%%%%%%%%%%%%%%%%%%%

g = 9.80665; % [m/s2]

aircraft.performance.cruise_mach = 0.8; % mach number taken from an average in our historical dataset

aircraft = generate_climb_segments(aircraft);

% TW and WS design point selection
aircraft.sizing.TW_design = 0.85; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM
aircraft.sizing.WS_design = 475; % A SPOT WE MANUALLY CHOOSE FROM THE TW-WS DIAGRAM

% Thrust and S design point guesses
aircraft.design_point.S_design = aircraft.weight.togw/aircraft.sizing.WS_design; % W /(W/S) = S [ m2]
aircraft.design_point.T_design = (aircraft.weight.togw*g)/aircraft.sizing.WS_design; % W [kg]*g[m/s2] * (T/W) = T [N]

end