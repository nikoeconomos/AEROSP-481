
function CD = drag_polar_calc(CD0, CL, AR, e)
    % Function to calculate total drag coefficient using the drag polar equation
    % Inputs:
    % CD0: Parasite drag coefficient (dimensionless)
    % CL: Lift coefficient (dimensionless)
    % AR: Aspect ratio of the wing (dimensionless)
    % e: Oswald efficiency factor (dimensionless)

    %TODO DELETE if old or TRANSFER TO GENERATE DRAG POLAR PARAMS.m if useful
    
    % Calculate induced drag factor k
    k = 1 / (pi * AR * e);
    
    % Parabolic drag polar equation
    CD = CD0 + k * CL^2;
end