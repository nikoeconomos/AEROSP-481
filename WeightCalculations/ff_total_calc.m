function [mission_ff] = ff_total_calc(aircraft)
% Description: This function calculates the total fuel fraction for the
% any mission profile. It does this by using values
% from a table of typical fuel fractions (table 2.2 in the metabook) for
% the Engine start and takeoff, Climb, and Descent mission segments. The
% remaining mission segments are calculated using the equations for Cruise
% and Loiter.
%
% mission profile specs are generated on a case by case basis in their
% respective functions
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft specifications struct.
%
% OUTPUTS:
% --------------------------------------------
%    mission_ff - Double. Fuel empty fraction calculated for DCA mission [unitless]
% 
% See also: generate_DCA_mission(), max_lift_to_drag(), TBU
% Author:                          niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% LD CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%

% Lift to drag estimated based on the F-35A, currently omitting the calculation method on the metabook, therefore
% function argument doesn't matter as lift_to_drag_calc() is currently defined and all argument values can be arbitrary.
[max_LD, cruise_LD] = LD_calc(); 

% Expecting decrease in aerodynamic efficiency during dash due to 
% supersonic flight conditions, arbitrarily picked a loss of 7%
dash_LD = 0.93 * cruise_LD; 

% Assuming aircraft is optimized for combat and has maximum lift_to_drag
% ratio during this mission segment

%% FUEL FRACTION DETERMINATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mission = aircraft.mission;
mission.ff = NaN(size(mission.segments));
for i = 1:length(aircraft.mission.segments)

    if mission.segments(i) == "takeoff"
        mission.ff(i) = 0.970; % [unitless]

    elseif mission.segments(i) == "climb"
        mission.ff(i) = 0.985;

    elseif mission.segments(i) == "cruise"
        mission.ff(i) = ff_cruise_calc(DCA_mission.cruise_out.range,DCA_mission.cruise_out.tsfc, ...
    DCA_mission.cruise_out.flight_velocity,cruise_lift_to_drag);

    elseif mission.segments(i) == "loiter"

    elseif mission.segments(i) == "dash"

    elseif mission.segments(i) == "combat"

    elseif mission.segments(i) == "optimize" % UNSURE IF NEEDED. From the "return to optimal alt/speed" line in RFP.
         mission.ff(i) = 1; % set to 1 so it has no effect on total

    elseif mission.segments(i) == "descent"
        mission.ff(i) = 0.990; % [unitless]
    
    elseif mission.segments(i) == "reserve"

    else
        error("Unaccepted mission segment variable name.")
    end



end



cruise_out_ff = 
 

loiter_ff = loiter_fuel_fraction_calc(DCA_mission.loiter.endurance,DCA_mission.loiter.tsfc,cruise_lift_to_drag);


dash_ff = cruise_fuel_fraction_calc(DCA_mission.dash.range,DCA_mission.dash.tsfc,DCA_mission.dash.flight_velocity, ...
    dash_lift_to_drag);


combat1_ff = cruise_fuel_fraction_calc(DCA_mission.combat1.range,DCA_mission.combat1.tsfc, ...
    DCA_mission.combat1.flight_velocity,max_lift_to_drag);


combat2_ff = cruise_fuel_fraction_calc(DCA_mission.combat2.range,DCA_mission.combat2.tsfc, ...
    DCA_mission.combat2.flight_velocity,max_lift_to_drag);



cruise_in_ff = cruise_fuel_fraction_calc(DCA_mission.cruise_in.range,DCA_mission.cruise_in.tsfc, ...
    DCA_mission.cruise_in.flight_velocity,cruise_lift_to_drag);

    % Descent segment
    

reserve_ff = loiter_fuel_fraction_calc(DCA_mission.reserve.endurance,DCA_mission.reserve.tsfc,cruise_lift_to_drag);

%% TOTAL FF CALCULATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Multiply fuel fractions at each stage to obtain total fuel empty fraction 
% from fuel consumption during mission segments

ff_total = mission.ff(1);
for i = 2:size(mission.ff) %start at the second index
    ff_total = ff_total*mission.ff(i);
end

% Second climb is accounted for in this equation with the same standard
% fuel fraction from Table 2.2 of the metabook TODO Juan what does this mean?

% Using equation 2.33 from metabook to account for trapped and reserve fuel
mission_ff = 1.06*(1-total_ff);

%% SAVE RESULT %%
%%%%%%%%%%%%%%%%%

aircraft.mission = mission;


end

