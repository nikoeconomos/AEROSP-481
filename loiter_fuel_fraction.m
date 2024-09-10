function [segment_fuel_fraction] = loiter_fuel_fraction(segment_endurance,specific_fuel_capacity,lift_to_drag)
% Description: This function generates a the TOGW of our aircraft by calling
% another function, togw_regression_loop. It runs the regression loop 3 times for all 
% three missions and returns three separate TOGWs.
% 
% INPUTS:
% --------------------------------------------
%    weight_params - Struct defined in generate_weight_params function.
%    Contains necessary parameters for the calculation.
% 
% OUTPUTS:
% --------------------------------------------
%    togw_DCA - TOGW for DCA [lbs]
%    togw_PDI - TOGW for PDI [lbs]
%    togw_ESCORT - TOGW for escort mission [lbs]
% 
% See also: togw_regression_loop()
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

segment_fuel_fraction = exp(-segment_endurance*specific_fuel_capacity/lift_to_drag);

end