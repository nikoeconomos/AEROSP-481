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

end