function [mission_ff] = DCA_fuel_fraction_calc(DCA_mission,LD,cruise_fuel_fraction,loiter_fuel_fraction)
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
%    LD - Double defined in max_lift_to_drag function. 
%    Aircraft lift to drag ratio [unitless]
%
%    cruise_fuel_fraction - Function outputting double. 
%    Calculates mission segment fuel fraction using equation for cruise [unitless]
%
%    loiter_fuel_fraction - Function outputting double. 
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

cruise_out_ff = cruise_fuel_fraction(DCA_mission.cruise_out.range,DCA_mission.cruise_out.tsfc,DCA_mission.cruise_out.flight_velocity,LD);

loiter_ff = loiter_fuel_fraction(DCA_mission.loiter.endurance,DCA_mission.loiter.tsfc,LD);

dash_ff = cruise_fuel_fraction(DCA_mission.dash.range,DCA_mission.dash.tsfc,DCA_mission.dash.flight_velocity,LD);

combat_ff = cruise_fuel_fraction(DCA_mission.combat.range,DCA_mission.combat.tsfc,DCA_mission.combat.flight_velocity,LD);

cruise_in_ff = cruise_fuel_fraction(DCA_mission.cruise_in.range,DCA_mission.cruise_in.tsfc,DCA_mission.cruise_in.flight_velocity,LD);

reserve_ff = loiter_ff(DCA_mission.reserve.endurance,DCA_mission.reserve.tsfc,LD);

total_ff = DCA_mission.start_takeoff.ff*DCA_mission.climb.ff*cruise_out_ff*loiter_ff*dash_ff*combat_ff*cruise_in_ff*DCA_mission.descent.ff*reserve_ff;

mission_ff = 1.06*(1-total_ff); % Using equation 2.33 from metabook to 
% account for trapped and reserve fuel

end