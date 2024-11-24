function [ff_total_adjusted] = ff_total_improved_calc(aircraft, W_0)
% Description: This function calculates the total fuel fraction from
% lecture slideshow 13
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

%% Update drag polar

S_wet = aircraft.geometry.S_wet_regression_calc(W_0); 

CD0   = aircraft.aerodynamics.CD0_calc(S_wet, aircraft.geometry.wing.S_ref); % Calculate C_D0 as function of S

aircraft = generate_drag_polar_params(aircraft, CD0); %Update drag polar with new CD0, based off of new W0


%% FUEL FRACTION DETERMINATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ff_current = 1;
mission = aircraft.mission;
mission.ff = NaN(size(mission.segments));

% this for loop goes through every defined mission segment and calculates
% the FF based on the defined type.
for i = 1:length(aircraft.mission.segments)

    if mission.segments(i) == "start"
        

        TSFC = mission.TSFC(i);
        time = mission.time(i);
        mission.ff(i) = 1 - TSFC * time * (0.05 * aircraft.propulsion.T_military / W_0); % 5% max thrust
    
    elseif mission.segments(i) == "takeoff"

        %mission.ff(i) = 0.995;
        TSFC = mission.TSFC(i);
        time = mission.time(i);
        mission.ff(i) = 1 - TSFC * time * (aircraft.propulsion.T_military / W_0); % max thrust 

    elseif mission.segments(i) == "climb"
        
        TSFC_SL        = mission.TSFC(i-1); % at takeoff
        TSFC_cruise    = mission.TSFC(i+1); % at cruise
        climb_altitude = mission.alt(i+1); % altitude of the next segment, usually cruise

        W_curr = W_0 * ff_current;

        % mission.ff(i) = 0.96; 
        mission.ff(i) = ff_climb_improved_calc(aircraft, TSFC_SL, TSFC_cruise, climb_altitude, W_curr);

    elseif mission.segments(i) == "cruise" || mission.segments(i) == "escort" % no restrictions on speed or L/D
        
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i); % find optimal
        altitude = mission.alt(i); % find optimal
        e = aircraft.aerodynamics.e.clean;

        W_curr = W_0 * ff_current;

        mission.ff(i) = ff_cruise_improved_calc(aircraft, range, TSFC, velocity, altitude, e, W_curr);

    elseif mission.segments(i) == "dash" % same as above, with different e
        
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        altitude = mission.alt(i); 
        e = aircraft.aerodynamics.e.supersonic; % estimated e value

        W_curr = W_0 * ff_current;

        mission.ff(i) = ff_cruise_improved_calc(aircraft, range, TSFC, velocity, altitude, e, W_curr);

    elseif mission.segments(i) == "combat" % differs only in LD from cruise, assumed to use max as it's optimized for combat
        
        mission.ff(i) = 0.99; % from max's code

    elseif mission.segments(i) == "loiter" || mission.segments(i) == "reserve" %  no difference between them
        endurance = mission.endurance(i);
        TSFC = mission.TSFC(i);
        e   = aircraft.aerodynamics.e.clean;
        CD0 = aircraft.aerodynamics.CD0.clean; % UPDATE FOR TRIM?

        LD_max = aircraft.aerodynamics.LD_max_calc(e, CD0); % Use LD max for loiter

        mission.ff(i) = ff_loiter_calc(endurance,TSFC,LD_max); 

    elseif mission.segments(i) == "optimize" % TODO: UNSURE IF NEEDED. From the "return to optimal alt/speed" line in RFP.
        
        mission.ff(i) = 1; % set to 1 so it has no effect on total

    elseif mission.segments(i) == "descent" % includes landing
        mission.ff(i) = 0.99 * 0.995; % [unitless] pulled from meta guide

    else
        error("Unaccepted mission segment variable name.")
    end

    ff_current = ff_current*mission.ff(i);

end

%% TOTAL FF CALCULATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

% Multiply fuel fractions at each stage to obtain total fuel empty fraction 
% from fuel consumption during mission segments

ff_total = mission.ff(1);
for i = 2:length(mission.ff) %start at the second index
    ff_total = ff_total*mission.ff(i);
end

% Using equation 2.33 from metabook to account for trapped and reserve fuel
ff_total_adjusted = 1.06*(1-ff_total);

end
