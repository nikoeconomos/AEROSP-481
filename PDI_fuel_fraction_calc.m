function [mission_ff] = PDI_fuel_fraction_calc(PDI_mission,cruise_fuel_fraction,lift_to_drag_calc)
% Description: This function calculates the total fuel fraction for the
% Point Defense Intercept (PDI) Mission. It does this by using values
% from a table of typical fuel fractions (table 2.2 in the metabook) for
% the Engine start and takeoff, Climb, and Descent mission segments. The
% remaining mission segments are calculated using the equations for Cruise
% and Loiter.
%
% The values inputted into these equations are calculated between lines 34
% & 44. They are defined in the generate_DCA_mission function where all
% relevant parameters are fitted into a single 3 layered struct.
% 
% INPUTS:
% --------------------------------------------
%    PDI_mission - Struct defined in generate_PDI_mission function. 
%    Contains mission segment parameters and aircraft states 
% 
%    lift_to_drag_calc function - used to calculate the L/D for cruise,
%    dash and the max below which feeds into the ff calculations for
%    corresponding mission segments.
%    Aircraft lift to drag ratio [unitless]
%
%    cruise_fuel_fraction - Function outputting double. 
%    Calculates mission segment fuel fraction using equation for cruise [unitless]
%
%
% OUTPUTS:
% --------------------------------------------
%    mission_ff - Double. Fuel empty fraction calculated for PDI mission [unitless]
% 
% See also: generate_PDI_mission(), max_lift_to_drag(), TBU
% Author:                          Shay
% Version history revision notes:
%                                  v1: 9/11/2024
[max_lift_to_drag,cruise_lift_to_drag] = lift_to_drag_calc(1,1,1); % Lift to drag estimated based on the F-35A,
% currently omitting the calculation method on the metabook, therefore
% function argument doesn't matter as lift_to_drag_calc() is currently
% defined and all argument values can be arbitrary.
dash_lift_to_drag = 0.93 * cruise_lift_to_drag; % Expecting decrease in aerodynamic efficiency during dash due to 
% supersonic flight conditions, arbitrarily picked a loss of 7%
% Assuming aircraft is optimized for combat and has maximum lift_to_drag
% ratio during this mission segment
dash_ff = cruise_fuel_fraction(PDI_mission.dash.range,PDI_mission.dash.tsfc,PDI_mission.dash.flight_velocity,dash_lift_to_drag);
combat1_ff = cruise_fuel_fraction(PDI_mission.combat1.range,PDI_mission.combat1.tsfc,PDI_mission.combat1.flight_velocity,max_lift_to_drag);
combat2_ff = cruise_fuel_fraction(PDI_mission.combat2.range, PDI_mission.combat2.tsfc, PDI_mission.combat2.flight_velocity,max_lift_to_drag);
cruise_in_ff = cruise_fuel_fraction(PDI_mission.cruise_in.range,PDI_mission.cruise_in.tsfc,PDI_mission.cruise_in.flight_velocity,cruise_lift_to_drag);
reserve_ff = loiter_ff(PDI_mission.reserve.endurance,PDI_mission.reserve.tsfc,cruise_lift_to_drag);
total_ff = PDI_mission.start_takeoff.ff*PDI_mission.climb.ff* ...
    dash_ff*combat1_ff*combat2_ff*cruise_in_ff*reserve_ff; 
    % Multiply fuel fractions at each stage to obtain total fuel empty fraction 
    % from fuel consumption during mission segments
    % not including decent in the calculation bc mission spec states that no fuel used
mission_ff = 1.06*(1 - total_ff); % Using equation 2.33 from metabook to 
% account for trapped and reserve fuel
end