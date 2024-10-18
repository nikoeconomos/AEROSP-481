function [ff_total_adjusted] = ff_total_calc(aircraft)
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

% Lift to drag estimated based on the F-35A, currently omitting the calculation method on the metabook
LD_max = 12;
LD_cruise = LD_max*0.943;

% Expecting decrease in aerodynamic efficiency during dash due to 
% supersonic flight conditions, arbitrarily picked a loss of 7%
LD_dash = 0.93 * LD_cruise; 

% Assuming aircraft is optimized for combat and has maximum lift_to_drag
% ratio during this mission segment

%% FUEL FRACTION DETERMINATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mission = aircraft.mission;
mission.ff = NaN(size(mission.segments));

% this for loop goes through every defined mission segment and calculates
% the FF based on the defined type.
for i = 1:length(aircraft.mission.segments)

    if mission.segments(i) == "start"
        mission.ff(i) = 1;

    elseif mission.segments(i) == "takeoff"
        mission.ff(i) = 0.970; % [unitless] pulled from meta guide

    elseif mission.segments(i) == "climb"
        mission.ff(i) = 0.985; % [unitless], pulled from meta guide

    elseif mission.segments(i) == "cruise"
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_cruise_calc(range, TSFC, velocity, LD_cruise);

    elseif mission.segments(i) == "dash" % differs only in LD from cruise
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_cruise_calc(range, TSFC, velocity, LD_dash);

    elseif mission.segments(i) == "combat" % differs only in LD from cruise, assumed to use max as it's optimized for combat
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_cruise_calc(range, TSFC, velocity, LD_max);

    elseif mission.segments(i) == "escort" % differs only in LD from cruise, assumed to use max but subject to change
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_cruise_calc(range, TSFC, velocity, LD_max);

    elseif mission.segments(i) == "loiter" || mission.segments(i) == "reserve" % currently no difference between them
        endurance = mission.endurance(i);
        TSFC = mission.TSFC(i);
        mission.ff(i) = ff_loiter_calc(endurance,TSFC,LD_cruise);

    elseif mission.segments(i) == "optimize" % TODO: UNSURE IF NEEDED. From the "return to optimal alt/speed" line in RFP.
        mission.ff(i) = 1; % set to 1 so it has no effect on total

    elseif mission.segments(i) == "descent"
        mission.ff(i) = 0.990; % [unitless] pulled from meta guide

    else
        error("Unaccepted mission segment variable name.")
    end

end

%% TOTAL FF CALCULATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Multiply fuel fractions at each stage to obtain total fuel empty fraction 
% from fuel consumption during mission segments

ff_total = mission.ff(1);
for i = 2:length(mission.ff) %start at the second index
    ff_total = ff_total*mission.ff(i);
end

% Second climb is accounted for in this equation with the same standard
% fuel fraction from Table 2.2 of the metabook TODO: Juan what does this
% mean? Can we take out optimize?

% Using equation 2.33 from metabook to account for trapped and reserve fuel
ff_total_adjusted = 1.06*(1-ff_total);
end

