function [mission_ff] = DCA_fuel_fraction_calc(DCA_mission)
% Description: This function calculates the total fuel fraction for the
% Direct Counter-Air (DCA) Patroll Mission. It does this by using values
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
%    DCA_mission - Struct defined in generate_DCA_mission function. 
%    Contains mission segment parameters and aircraft states 
% 
%    lift_to_drag_calc - Function outputting double. 
%    Aircraft lift to drag ratio [unitless]
%
%    cruise_fuel_fraction_calc - Function outputting double. 
%    Calculates mission segment fuel fraction using equation for cruise [unitless]
%
%    loiter_fuel_fraction_calc - Function outputting double. 
%    Calculates mission segment fuel fraction using equation for loitering [unitless]
%
% OUTPUTS:
% --------------------------------------------
%    mission_ff - Double. Fuel empty fraction calculated for DCA mission [unitless]
% 
% See also: generate_DCA_mission(), max_lift_to_drag(), TBU
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/10/2024

[max_lift_to_drag,cruise_lift_to_drag] = lift_to_drag_calc(); % Lift to drag estimated based on the F-35A,
% currently omitting the calculation method on the metabook, therefore
% function argument doesn't matter as lift_to_drag_calc() is currently
% defined and all argument values can be arbitrary.

dash_lift_to_drag = 0.93 * cruise_lift_to_drag; % Expecting decrease in aerodynamic efficiency during dash due to 
% supersonic flight conditions, arbitrarily picked a loss of 7%

% Assuming aircraft is optimized for combat and has maximum lift_to_drag
% ratio during this mission segment

cruise_out_ff = cruise_fuel_fraction_calc(DCA_mission.cruise_out.range,DCA_mission.cruise_out.tsfc, ...
    DCA_mission.cruise_out.flight_velocity,cruise_lift_to_drag);
 

loiter_ff = loiter_fuel_fraction_calc(DCA_mission.loiter.endurance,DCA_mission.loiter.tsfc,cruise_lift_to_drag);


dash_ff = cruise_fuel_fraction_calc(DCA_mission.dash.range,DCA_mission.dash.tsfc,DCA_mission.dash.flight_velocity, ...
    dash_lift_to_drag);


combat1_ff = cruise_fuel_fraction_calc(DCA_mission.combat1.range,DCA_mission.combat1.tsfc, ...
    DCA_mission.combat1.flight_velocity,max_lift_to_drag);


combat2_ff = cruise_fuel_fraction_calc(DCA_mission.combat2.range,DCA_mission.combat2.tsfc, ...
    DCA_mission.combat2.flight_velocity,max_lift_to_drag);


cruise_in_ff = cruise_fuel_fraction_calc(DCA_mission.cruise_in.range,DCA_mission.cruise_in.tsfc, ...
    DCA_mission.cruise_in.flight_velocity,cruise_lift_to_drag);


reserve_ff = loiter_fuel_fraction_calc(DCA_mission.reserve.endurance,DCA_mission.reserve.tsfc,cruise_lift_to_drag);


total_ff = DCA_mission.start_takeoff.ff * DCA_mission.climb.ff * cruise_out_ff * loiter_ff * dash_ff * combat1_ff ...
    * combat2_ff * DCA_mission.climb.ff * cruise_in_ff * reserve_ff; 
    % Multiply fuel fractions at each stage to obtain total fuel empty fraction 
    % from fuel consumption during mission segments

    % Second climb is accounted for in this equation with the same standard
    % fuel fraction from Table 2.2 of the metabook

    mission_ff = 1.06*(1-total_ff); % Using equation 2.33 from metabook to 
% account for trapped and reserve fuel

end