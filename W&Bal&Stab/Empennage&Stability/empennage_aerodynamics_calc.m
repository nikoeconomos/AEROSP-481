function [aircraft] = empennage_aerodynamics_calc(aircraft)
% Description:
% Generates parameters that refine sizing and aerodynamics for the
% empennage
%
% INPUTS:
% --------------------------------------------
%    aircraft
%
% OUTPUTS:
% --------------------------------------------
%    
%    aircraft
%
% 
% Author:                          Juan
% Version history revision notes:
%                                  v2: 11/15/2024

% TODO VERIFY the values and formulas.

% gamma_vtail = atand(S_VT/S_HT); % degrees

%% OEI Yaw Moment Calculation
To_thrust = 57.8e3;

yt = 0.8;

Nt_crit = To_thrust*yt;
Nt_drag = Nt_crit*0.15;
Nt_tot  = Nt_drag + Nt_crit;


%% Horizontal Stabilizer Lift Properties %%

% CL alpha calculation Mach numbers
M_takeoff    = 0.18;
M_c          = 0.548; % is this cruise or climb?
M_supersonic = 1;

% Wing CL alpha calculations
CL_a_w_to = 2*pi*wing.AR / (2 + sqrt( (wing.AR/0.97)^2 * (1 + tan(wing.sweep_LE)^2 - M_takeoff^2) + 4)); % TODO CONFIRM sweep is for leading edge, not QC or whatever
CL_a_w_c  = 2*pi*wing.AR / (2 + sqrt( (wing.AR/0.97)^2 * (1 + tan(wing.sweep_LE)^2 - M_c^2) + 4));
CL_a_w_s  = 2*pi*wing.AR / (2 + sqrt( (wing.AR/0.97)^2 * (1 + tan(wing.sweep_LE)^2 - M_supersonic^2) + 4));

% Downwash correction for regression H tail CL alpha
dw_corr_to = 2*CL_a_w_to / (pi*wing.AR);
dw_corr_c  = 2*CL_a_w_c  / (pi*wing.AR);
dw_corr_s  = 2*CL_a_w_s  / (pi*wing.AR);


%%%%%%%%%%%%%%%
%% PDR plots %%
%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takeoff Chordwise Mach = 0.18
aoa = [0 1 1.5 1.7 2 2.5 2.9]; % AOA until stall TODO WHERE did these come from?
c_L = [0  0.10357  0.15514  0.1757  0.20667  0.27675  0.31947]; % Lift CoefficientTODO WHERE did these come from?

% Linear regression
p_takeoff = polyfit(aoa, c_L, 1); % Fit a line (1st order polynomial)
p_takeoff_dw = p_takeoff*dw_corr_to
c_L_calc_1 = polyval(p_takeoff, aoa); % Calculate fitted values

% Plot 1
figure()
scatter(aoa, c_L)
hold on
plot(aoa, c_L_calc_1, 'LineWidth', 1.5)
xlabel('Angle of Attack (degrees)')
ylabel('Lift Coefficient')
title('Horizontal Stabilizer C_L Alpha at M = 0.18')
grid on
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takeoff Chordwise Mach = 0.548
aoa = [0 0.3 0.7 1 1.25 1.37 1.5]; % AOA until stall TODO WHERE did these come from?
c_L = [0 0.03609 0.08422  0.12034 0.15047 0.16497 0.18069]; % Lift Coefficient TODO WHERE did these come from?

% Linear regression
p_cruise = polyfit(aoa, c_L, 1); % Fit a line (1st order polynomial)
p_cruise_dw = p_cruise*dw_corr_c
c_L_calc_1 = polyval(p_cruise, aoa); % Calculate fitted values

% Plot 2
figure()
scatter(aoa, c_L)
hold on
plot(aoa, c_L_calc_1, 'LineWidth', 1.5)
xlabel('Angle of Attack (degrees)')
ylabel('Lift Coefficient')
title('Horizontal Stabilizer C_L Alpha at M = 0.548')
grid on
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Takeoff Chordwise Mach = 1
aoa = [0 1 2 3 5 8 11]; % AOA until stall
c_L = [0.1 0.15 0.25 0.31 0.52 0.92 1.1]; % Lift Coefficient

% Linear regression
p_supersonic = polyfit(aoa, c_L, 1);% Fit a line (1st order polynomial)
p_supersonic_dw = p_supersonic*dw_corr_s
c_L_calc_3 = polyval(p_supersonic, aoa); % Calculate fitted values

% Plot
figure()
scatter(aoa, c_L)
hold on
plot(aoa, c_L_calc_3, 'LineWidth', 1.5)
xlabel('Angle of Attack (degrees)')
ylabel('Lift Coefficient')
title('Horizontal Stabilizer C_L Alpha at M = 1')
grid on
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end