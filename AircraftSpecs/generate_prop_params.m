% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_prop_params(aircraft)
% Description: This function generates a struct that holds parameters related to the propulsion system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with propulsion
%    parameters
%                       
% 
% See also: None
% Author:                          Joon
% Version history revision notes:
%                                  v1: 9/13/2024
%                                  v2: 9/15/2024: Altered input arguments
%                                  to match format of parameter generation
%                                  codes.

%% PARAMETERS %%
%%%%%%%%%%%%%%%%

% number of engines
aircraft.propulsion.num_engines = 1;

% max thrust
aircraft.propulsion.T_max = aircraft.propulsion.num_engines*131200; %[N] TOTAL THRUST FROM BOTH ENGINES

% military thrust
aircraft.propulsion.T_military = aircraft.propulsion.num_engines*76300; %[N] TOTAL THRUST FROM BOTH ENGINES


end