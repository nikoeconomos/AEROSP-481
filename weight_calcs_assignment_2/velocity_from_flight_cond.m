function flight_velocity = velocity_from_flight_cond(mach,t_amb,rho,r_air)
% Description: This function calculates the aircraft's velocity from its
% mach number and the atmospheric temperature and density at its current
% flight altitude
% 
% INPUTS:
% --------------------------------------------
%    mach - Double defined in fuel_weight function. 
%    Aircraft Mach number [unitless] 
% 
%    t_amb - Double defined in fuel_weight function 
%    Atmospheric temperature at current aircraft altitude [K]
% 
%    rho - Double defined in fuel_weight function
%    Density of air at current aircraft altitude [kg/m^3]
% 
%    r_air -  Double defined in main.m 
%    Gas constant for air [unitless]
%
% OUTPUTS:
% --------------------------------------------
%    flight_velocity - Double. Aircraft velocity at atmospheric conditions [m/s]
% 
% See also: main.m, fuel_weight()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

a = sqrt(r_air*t_amb*rho); % Speed of sound calculated from temperature, 
% gas constant of air, and denisty at flight altitude

flight_velocity = a*mach; % Solve for velocity from relationship with mach number 
% and speed of sound

end