function aircraft = SM_calc_plot(aircraft)
% Description: Using values obtained from cg_excursion_calc.m to find
% changes in static margin
% 
% 
% INPUTS:
% --------------------------------------------
%    cg_excursion_arr -- array of cg locations over an excursion
% 
% OUTPUTS:
% --------------------------------------------
%    sm_arr -- array of static margins over an excursion
%    np_arr -- array of neutral points over an excursion
%                       
% 
% See also: 
% script
% Author:                          Joon Kyo Kim
% Version history revision notes:
%                                  v1: 10/27/24

    %% SET VALUES %%

    mach = aircraft.performance.mach.arr;
    cg_excursion_arr = aircraft.weight.cg.excursion_arr_full_mission; % Calculated previously in CG_calc_plot. Full mission start to finish
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% CALCULATE CL ALPHA OF WING %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    C_l_alpha_w = zeros(1 , length(mach));

    % These values come from CFD from Juan. THESE ARE Cl alpha, NOT CLALPHA
    C_l_alpha_w(1) = 6.01; 
    C_l_alpha_w(2) = 6.31;
    C_l_alpha_w(3) = 6.69;
    C_l_alpha_w(4) = 7.46;
    C_l_alpha_w(5) = 6.45;
    C_l_alpha_w(6) = 7.09;

    %% Subsonic

    beta_subsonic = sqrt(1-mach.^2);

    eta_w = C_l_alpha_w ./ (2*pi./beta_subsonic);
    aircraft.aerodynamics.eta.wing = eta_w;

    AR_w = aircraft.geometry.wing.AR;

    exposed_ratio = aircraft.geometry.wing.S_exposed/aircraft.geometry.wing.S_ref;

    %F = 1.07*(1+aircraft.geometry.fuselage.width/aircraft.geometry.wing.AR)^2; % fuselage lift factor raymer 12.9
           
    Lambda_HC_w = aircraft.geometry.wing.sweep_HC; 
    Lambda_LE_w = aircraft.geometry.wing.sweep_LE;

    C_L_alpha_w   = (2*pi*AR_w) ./ (2 + sqrt(4+( (AR_w^2.*beta_subsonic.^2)./(eta_w.^2) .* (1 + tan(Lambda_HC_w)^2./beta_subsonic.^2) ) ) ) * exposed_ratio; % Metabook 8.18
    C_L_alpha_w(3:end) = NaN;  % This ONLY works up to 0.85, so take out the last 3 vals.

    %% Supersonic 

    % Process in raymer 12.4.2
    beta_supersonic = sqrt(mach.^2-1);

    x_axis_val = 1/(beta_supersonic(6)/tan(Lambda_LE_w));
    y_axis_val = AR_w*tan(Lambda_LE_w);

    chart_val = 3.8;

    C_L_alpha_w(6) = chart_val/beta_supersonic(6) * exposed_ratio;

    %% Transonic

    % These are estimated value to make a faired curve, not very good estimates
    C_L_alpha_w(3) = 2.15;
    C_L_alpha_w(4) = 2.2;
    C_L_alpha_w(5) = 2;

    %% Assign

    aircraft.stability.C_L_alpha.wing = C_L_alpha_w;
    
    %% Plot the curve
    % Define colors from the palette
    dark_blue = [0.20, 0.30, 0.40];  % Dark bluish-gray for the line
    light_blue = [0.70, 0.80, 0.90];  % Soft light blue for the marker face
    
    % Plot original data points
    figure();
    plot(mach, C_L_alpha_w, 'o', 'MarkerFaceColor', light_blue, 'MarkerEdgeColor', dark_blue);
    hold on;
    
    % Generate a dense set of x values for the spline interpolation
    mach_dense = linspace(min(mach), max(mach), 200);
    
    % Fit a cubic spline to all data points
    C_L_alpha_w_smooth = spline(mach, C_L_alpha_w, mach_dense);
    
    % Plot the smooth spline curve
    plot(mach_dense, C_L_alpha_w_smooth, '--', 'LineWidth', 1.5, 'Color', dark_blue);
    
    % Set y-axis limits from 0 to 4
    ylim([0 4]);
    
    % Customize the plot
    xlabel('Mach');
    ylabel('C_L_\alpha_w');
    title('C_L_\alpha_w vs. Mach number, faired curve (estimation)');
    legend('Data Points', 'Spline Fit Curve');
    hold off;

    %%%%%%%%%%%%%%%%%%%%%%
    %% CL ALPHA OF TAIL %%
    %%%%%%%%%%%%%%%%%%%%%%
   
    AR_h = aircraft.geometry.htail.AR;
    eta_h = aircraft.aerodynamics.eta.htail; %tail efficiency: taking into account downwash
    
    Lambda_HC_h = aircraft.geometry.htail.sweep_HC;
    
    %% Subsonic

    C_L_alpha_h_0        = (2*pi*AR_h) ./ (2 + sqrt(4+( (AR_h^2.*beta_subsonic.^2)./(eta_h.^2) .* (1 + tan(Lambda_HC_h)^2./beta_subsonic.^2) ) ) ); % Metabook 8.18
    
    de_da       = 2.00*C_L_alpha_w / (pi*AR_w);   % metabook
    C_L_alpha_h = C_L_alpha_h_0.*(1 - de_da).*eta_h; % 8.21

    C_L_alpha_h(3:end) = NaN;

    %% Trans and supersonic 

    % estimates to make a faired curve
    C_L_alpha_h(3) = 1.81;
    C_L_alpha_h(4) = 1.85;
    C_L_alpha_h(5) = 1.7;
    C_L_alpha_h(6) = 1.6132;

    %% Assign

    aircraft.stability.C_L_alpha.htail = C_L_alpha_h;

    %% Plots

    % Define colors from the palette
    dark_blue = [0.20, 0.30, 0.40];  % Dark bluish-gray for the line
    light_blue = [0.70, 0.80, 0.90];  % Soft light blue for the marker face
    
    % Plot original data points
    figure();
    plot(mach, C_L_alpha_h, 'o', 'MarkerFaceColor', light_blue, 'MarkerEdgeColor', dark_blue);
    hold on;
    
    % Generate a dense set of x values for the spline interpolation
    mach_dense = linspace(min(mach), max(mach), 200);
    
    % Fit a cubic spline to all data points
    C_L_alpha_h_smooth = spline(mach, C_L_alpha_h, mach_dense);
    
    % Plot the smooth spline curve
    plot(mach_dense, C_L_alpha_h_smooth, '--', 'LineWidth', 1.5, 'Color', dark_blue);
    
    % Set y-axis limits from 0 to 4
    ylim([0 4]);
    
    % Customize the plot
    xlabel('Mach');
    ylabel('C_L_\alpha_h');
    title('C_L_\alpha_h vs. Mach number, faired curve (estimation)');
    legend('Data Points', 'Spline Fit Curve');
    hold off;
    
    %%%%%%%%%%%%%
    %% SM CALC %%
    %%%%%%%%%%%%%
    
    %% Finding Kf based on location of wing quarter chord

    % Values from metabook table 8.1
    x = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7]; % 1/4 chord position
    y = [0.115, 0.172, 0.344, 0.487, 0.688, 0.888, 1.146]; % Kf values
    
    % Fit a polynomial to the data
    p = polyfit(x, y, 2); % Second-degree polynomial
    
    K_f = polyval(p, aircraft.geometry.wing.xR25/aircraft.geometry.fuselage.length);


    %% More values

    w_f = aircraft.geometry.fuselage.width; % max width of fuselage
    L_f = aircraft.geometry.fuselage.length; % length of fuselage
    
    S_w = aircraft.geometry.wing.S_ref;
    S_h = aircraft.geometry.htail.S_ref;
    
    MAC    = aircraft.geometry.wing.MAC;
    x25MAC = aircraft.geometry.wing.xMAC+0.25*MAC;
    x50MAC = aircraft.geometry.wing.xMAC+0.5*MAC;
    l_h    = aircraft.geometry.htail.xMAC - cg_excursion_arr(:,1); % Distance between CG and tail MAC

    C_M_fus_CL = K_f * w_f^2 * L_f ./ (S_w * MAC * C_L_alpha_w);

    if mach > 1
        x_cg_dist_from_ac = cg_excursion_arr(:,1)-x50MAC;
    else
        x_cg_dist_from_ac = cg_excursion_arr(:,1)-x25MAC;
    end

    sm_arr = -( x_cg_dist_from_ac./MAC - (C_L_alpha_h .*S_h .*l_h) ./ (C_L_alpha_w .* S_w .*MAC) + C_M_fus_CL); %metabook 8.23
    aircraft.stability.static_margin_arr = sm_arr;
    
    np_arr = sm_arr*MAC + cg_excursion_arr(:,1);
    aircraft.stability.neutral_point_arr = np_arr;
    
    np_mach_arr = np_arr(1,:);
    
    %% PLOT %%
    
% Define a colormap for different shades of blue with more variation
num_lines = length(sm_arr(1,:));
color_map = lines(num_lines); % Use the 'lines' colormap, which provides distinct colors

% Neutral Point Plot
figure;
plot(mach, np_mach_arr, '-o', 'MarkerFaceColor', 'k', 'Color', [0.30, 0.50, 0.70], 'LineWidth', 1);
title('Neutral Point Location at Varying Mach Numbers');
xlabel('Mach');
ylabel('x_n_p (m, from nose tip)');
xline(1, '--', 'Color', 'k'); % Dashed vertical line at Mach = 1
hold off;

% Static Margin Excursion Plot
figure;
hold on;
for i = 1:num_lines
    % Use a distinct color from the colormap for each line
    plot(cg_excursion_arr(5:end, 1), sm_arr(5:end, i)', '-o', 'MarkerFaceColor', 'k', 'Color', color_map(i, :), 'LineWidth', 1);
end
yline(0, '--', 'Color', 'k'); % Dashed horizontal line at y = 0
yline(-0.1,'--r');
yline(0.1,'--r');
legendLabels = arrayfun(@(x) "M = " + x, mach, 'UniformOutput', false); % Generate legend strings
legend(legendLabels, 'Location', 'Best');
title('Static Margin Excursion Plot for Varying Mach Numbers');
xlabel('CG Location With Respect to Nose');
ylabel('SM');
hold off;




end