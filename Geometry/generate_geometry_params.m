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

ft2_to_m2 = 0.092903;
kg_to_lb = 2.20462;

aircraft.geometry.AR = 2.663; % [unitless] % Of the F35. TODO CHANGE ESTIMATE

c = -0.1289;
d = 0.7506;

S_wet = 10^(c)*(aircraft.weight.togw*kg_to_lb)^d; % [ft^2] %Wetted surface area estimate, eq metabook 4.9, roskam table 3.22 fighter
aircraft.geometry.S_wet = S_wet*ft2_to_m2; % [m^2]

aircraft.geometry.S_ref = 0.75*aircraft.geometry.S_wet/aircraft.geometry.AR ; % [m] % Estimated from wetted aspect ratio graph, given a LDmax of 12 (fig 2.4 metabook)

%aircraft.geometry.S = ??; %Todo uncomment when found
end