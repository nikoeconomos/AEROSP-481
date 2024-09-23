function C_D0 = parasite_drag_calc(W0, S_ref, Cf, c, d, delta_CD0)
    % Description:
    % Function to calculate the parasite drag coefficient (C_D0)

    % Inputs:
    % W0: Takeoff gross weight (kg) 
    % S_ref: Wing reference area (ft²)
    % Cf: Skin friction coefficient (unitless)
    % c, d: Constants for aircraft type (from table)
    % delta_CD0: Additional drag due to configuration (flaps, landing gear)
    
    % Calculate wetted area (S_wet)
    S_wet = (10^(c)) * (W0^(d));
    
    % Calculate parasite drag coefficient (C_D0)
    C_D0 = Cf * (S_wet / S_ref) + delta_CD0;
end