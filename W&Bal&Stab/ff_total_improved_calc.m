function [ff_total_adjusted] = ff_total_improved_calc(aircraft, W_0, Sin)
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

%% Calculate CD0, CL, LD for a given S TODO UPDATE

% NOTE: This LD does not change based on the part of flight we're on. (takeoff, climb, cruise, dash, etc). This may need to be accounted for later.

S_wet = aircraft.geometry.S_wet_regression_calc(W_0); % 4* sin

CD0   = aircraft.aerodynamics.CD0_calc(S_wet, Sin); % Calculate C_D0 as function of S

e = aircraft.aerodynamics.e.cruise; % TODO UPDATE: this should change based on the part of flight we're in?
k = aircraft.aerodynamics.k_calc(e);

CL = aircraft.aerodynamics.CL_from_CD0_calc(CD0, k);

LD = aircraft.aerodynamics.LD_from_CL_and_CD0_calc(CL, CD0, k);

%% FUEL FRACTION DETERMINATION %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mission = aircraft.mission;
mission.ff = NaN(size(mission.segments));

% this for loop goes through every defined mission segment and calculates
% the FF based on the defined type.
for i = 1:length(aircraft.mission.segments)

    if mission.segments(i) == "start"
        
        %mission.ff(i) = 1 - TSFC * time * (0.05 * T_0 / W_0); % 5% max thrust
        % FROM LECTURE, PUT CALC DIRECTLY IN HERE, VERITY THE COMMENTED
        % ONE
    
    elseif mission.segments(i) == "takeoff"

        %mission.ff(i) = 1 - TSFC * time * (T_0 / W_0); % max thrust  FROM
        %LECTURE PUT DIRECTLY HERE VERITY THE COMMENTED
        % ONE

    elseif mission.segments(i) == "climb"
        
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_climb_improved_calc(); % INSERT WHAT YOU NEED IN PARENTHESIS, NOT SURE IF ABOVE IS NEEDED

    elseif mission.segments(i) == "cruise" || mission.segments(i) == "dash" || mission.segments(i) == "escort" 
        
        range = mission.range(i);
        TSFC = mission.TSFC(i);
        velocity = mission.velocity(i);
        mission.ff(i) = ff_cruise_improved_calc(range, TSFC, velocity, LD); % TODO UPDATE

    elseif mission.segments(i) == "combat" % differs only in LD from cruise, assumed to use max as it's optimized for combat
        
        mission.ff(i) = 0.99; % from max's code, TODO improve??

    elseif mission.segments(i) == "loiter" || mission.segments(i) == "reserve" % currently no difference between them
        
        endurance = mission.endurance(i);
        TSFC = mission.TSFC(i);
        mission.ff(i) = ff_loiter_improved_calc(endurance,TSFC,LD); % TODO UPDATE

    elseif mission.segments(i) == "optimize" % TODO: UNSURE IF NEEDED. From the "return to optimal alt/speed" line in RFP.
        
        mission.ff(i) = 1; % set to 1 so it has no effect on total

    elseif mission.segments(i) == "descent"
        mission.ff(i) = 0.98; % KEEP THE SAME

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

% Using equation 2.33 from metabook to account for trapped and reserve fuel
ff_total_adjusted = 1.06*(1-ff_total);

end

