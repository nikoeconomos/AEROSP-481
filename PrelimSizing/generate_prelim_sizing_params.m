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

%% ***CATEGORY*** %%
%%%%%%%%%%%%%%%%%%%%

aircraft.performance.cruise_mach = 0.8; % mach number taken from an average in our historical dataset

aircraft = generate_climb_segments(aircraft);

% Thrust design point
aircraft.design_point.T_des = 191000; %N

% S design point put in
aircraft.design_point.S_des = 41; %m2
end