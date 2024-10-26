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

% [m^2]  %table 3.5 Roskam, values for clean MTOW, for fighter jet / figure 3.22, eq metabook 4.9
% CHANGE IF WRONG

aircraft.geometry.S_wet_regression_calc = @(W0) ConvArea( 10^(-0.1289)*(ConvMass(W0,'kg','lbm'))^0.7506, 'ft2','m2'); 

aircraft.geometry.length_regression_calc = @(W0) 0.389*W0^0.39; % this is a historical regression from Raymer table 6.3

aircraft.geometry.wing.AR = 3.068; %From raymer calc
aircraft.geometry.wing.sweep_LE = deg2rad(44.9); %radians
aircraft.geometry.wing.S_ref = 24.5;

end