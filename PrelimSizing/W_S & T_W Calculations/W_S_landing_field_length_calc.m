function W_S = W_S_landing_field_length_calc(aircraft)
% Description: This function generates a W/S  value for a
% constraint diagram that is based on our landing distance requirement.
% Note that this equation is independent of T/W. Also note that the value
% of 80 in the equation below was not assumed, but rather is a part of the
% equation straight from the textbook.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct
%    
% 
% OUTPUTS:
% --------------------------------------------
%    W_S - a single wing loading value that must be met in order to land in
%    a distance of 8,000 ft (given current CL_max)
%                       
% 
% See also: generate_prelim_sizing_params.m 
% script
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/22/2024

ks = .107; %[kg/m^3] - comes from raymer textbook LDG equation
landing_distance = 2438.4; %[m] which is = 8,000 ft (from RFP)
Sa = 182.88; %[m] - military aircraft Sa distance according to raymer txtbook (WHERE?) (essentially an "error" factor)

landing_distance_adjusted = landing_distance - Sa; %[m] - essentially an error calc - the landing distance availible must be > landing distance it takes by 600 ft

rho_SL_45C = aircraft.environment.rho_SL_45C; %[kg/m^3]
[~,~, rho_1219_MSL, ~] = standard_atmosphere_calc(1219.2); %[kg/m^3] - calculating this at 4000 ft MSL, 1219.2 m, per RFP

CL_max = aircraft.aerodynamics.CL_landing_flaps;   

W_S = ks*(rho_1219_MSL/rho_SL_45C)*CL_max*landing_distance_adjusted; %[kg/m^2]

%(((rho/rho_SL)*CL_max) / 80)*(landing_distance*1.67-Sa); % multiply by 1.67 for the 2/3 safety margin

end
