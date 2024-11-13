function ff_climb = ff_climb_improved_calc(aircraft, TSFC_SL, TSFC_alt, climb_alt, W_curr)
% Description: 
% 
% INPUTS:
% --------------------------------------------
%    TSFC, cruise_alt, e, CD0 = all for 
% 
%    
%
% OUTPUTS:
% --------------------------------------------
%    ff_climb = ff for a full climb
% 
% Author:                          Niko
% Version history revision notes:
%                                  v1: 11/12/2024


%% initialize values

g = 9.81;
S_ref = aircraft.geometry.wing.S_ref;

n = 500;
segment_height_change = climb_alt / n;  % Range of each segment

ff_segments = zeros(1,n);
h_e   = zeros(1,n);

h = 0;
W_i = W_curr;

for i = 1:n

    %% find which CD_0, e, k, and rho from altitude
    if h < 100
        CD0 = aircraft.aerodynamics.CD0.takeoff_flaps_gear; % for immediately after takeoff, less than 100m (chatgpt)
        e   = aircraft.aerodynamics.e.takeoff_flaps;
    elseif h >= 100 && h < 400
        CD0 = aircraft.aerodynamics.CD0.takeoff_flaps; % takeoff flaps only, less than 400 meters (chatgpt)
        e   = aircraft.aerodynamics.e.takeoff_flaps;
    else
        CD0 = aircraft.aerodynamics.CD0.clean; % rest of climb
        e   = aircraft.aerodynamics.e.clean;
    end
    % k from the e decide above
    k = aircraft.aerodynamics.k_calc(e);

    [~, ~, rho, ~] = standard_atmosphere_calc(h);     % rho at current altitude

    %% thrust scaling based on altitude calculation based on h

    % linearly scale TSFC from takeoff values to cruise values based on altitude TODO improve
    TSFC_i = TSFC_SL + (TSFC_alt-TSFC_SL)*i/n;

    % linearly scale thrust from density
    T_i = thrust_from_alt(aircraft.propulsion.T_military, h); % Linear scaling with density vs SL density

    %% calculations, from slide 54  in presentation 13
    V_i = sqrt( ( ( W_i*g / S_ref) / (3 * rho * CD0) ) * (T_i/ (W_i*g) ) + sqrt( (T_i/ (W_i*g) )^2 + 12*CD0*k ) );

    CL_i = (2 * W_i * g / (rho * V_i^2 * S_ref)); 
    CD_i = CD0 + k*CL_i^2;
    D_i   = (rho*V_i^2) / 2 * S_ref * CD_i;

    h_e(i) = h + V_i^2/(2*g);
    if i == 1 % if first iteration, delta h is just the value
        delta_h_e = h_e(i);
    else
        delta_h_e(i) = h_e(i) - h_e(i-1);
    end
        
    ff_segments(i) = exp( -(TSFC_i * delta_h_e(i)) / (V_i * (1 - D_i/T_i) ) );

    W_i = ff_segments(i)*W_i;

    h = h + segment_height_change;
end

ff_climb = 1;
for i = 1:length(ff_segments) %start at the second index
    ff_climb = ff_climb*ff_segments(i);
end

end