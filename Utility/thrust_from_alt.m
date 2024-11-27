function [T_adjusted] = thrust_from_alt(T_orig, alt)
% Description: calculates thrust from altitude based on a linear
% relationship between rho at sea level and rho at altitude
%
%
% MADE BY: Niko 11/12

% Assume alt is the altitude at which you want to calculate adjusted thrust
[~, ~, rho_SL, ~] = standard_atmosphere_calc(0);     % Sea-level density
[~, ~, rho_alt, ~] = standard_atmosphere_calc(alt);  % Density at altitude 'alt'

rho_ratio = rho_alt / rho_SL;  % Ratio of density at altitude to sea-level density

% Adjusted thrust based on density ratio
T_adjusted = T_orig * rho_ratio;

end