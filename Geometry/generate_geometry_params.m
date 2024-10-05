% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_geometry_params(aircraft)
% Description: This function generates a struct that holds parameters used in
% calculating the cost of the geometry of the aircraft.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with geometry
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% WING %%
%%%%%%%%%%%%%%%%%%

aircraft.geometry.S_wet = S_wet_calc(aircraft.weight.togw); % [m^2]

aircraft.geometry.S_wet_over_S_ref = 4.15; % Estimated from wetted area ratio graph, eyeballed it [CURRENTLY DEPRECATED]

aircraft.geometry.S_ref = S_ref_from_S_wet_calc(aircraft, aircraft.geometry.S_wet); % [m] 

aircraft.geometry.AR = 6; %Estimate! SWEEP THROUGH AND CHANGE!

%aircraft.geometry.S = ??; %Todo uncomment when found
end