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

aircraft.wing.placeholder = 0; %placeholder
aircraft.geometry.aspect_ratio = 2.66; %Assumed from F-35
aircraft.geometry.AR = 2.663; % Of the F35. TODO CHANGE ESTIMATE

S_wet = 10^(-.1289)*(aircraft.weight.togw)^0.7506; %Wetted surface area estimate, ft2
aircraft.aerodynamics.S_wet = S_wet*0.092903;
aircraft.geometry.S_ref = 0.75*aircraft.aerodynamics.S_wet/aircraft.geometry.aspect_ratio; % Estimated from wetted aspect ratio graph (fig 2.4)

end