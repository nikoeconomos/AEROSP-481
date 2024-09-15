% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_aerodynamics_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the aerodynamics system of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with aerodynamics
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Lift to Drag %%
%%%%%%%%%%%%%%%%%%

[LD_max, LD_cruise] = LD_calc();

aircraft.aerodynamics.LD_max = LD_max;
aircraft.aerodynamics.LD_cruise = LD_cruise;


end