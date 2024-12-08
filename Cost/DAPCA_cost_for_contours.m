% Aerosp 481 Group 3 - Libellula 
function [cost_curr] = DAPCA_cost_for_contours(aircraft, W_e, T_max)
% Description: This function is only for use with creating contours.
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with cost
%    parameters and W_e, empty weight of AC
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 12/8/24

cost = struct();

target_year = 2024;

x = 0.926; %(95% learning curve))
learning_curve_95 = @(H1, Q) H1 * (1/Q)^(1-x);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% DAPCA IV CALCULATIONS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% IMPORTANT VARIABLES

DAPCA_base_year = 2012;

[~, ~, rho_SL, ~] = standard_atmosphere_calc(0); % kg/m3
[~, ~, rho_c,  ~] = standard_atmosphere_calc(10668); % kg/m3
TAS_to_EAS = @(V_tas, rho) V_tas * sqrt(rho / rho_SL); % TAS to EAS conversion

V_max_tas = velocity_from_flight_cond(aircraft.performance.mach.dash, 10668);
V_max     = TAS_to_EAS(V_max_tas, rho_c); % m/s of EAS

Q = 1000; % Production number
FTA = 6; % Flight test aircraft

fudge_factor_composite = 1.8; % for materials pg 697


%% Engine & Avionics

cost_avi_percent_flyaway = 0.4; % raymer pg 698, can be bumped up to 40 according to roskam pg 367 sec 8

% engine cost, based on contract with Lockhead Martin F-16 Fleet in 2000 (adjusted for inflation)
M_max = 2.5; % found online
T_inlet = 1973.15; %found online
C_engine_base = 3112*(9.66*T_max + 243.25*M_max + 1.74*T_inlet - 2228); 

N_eng = Q;

cost.RTDE_flyaway.engines = adjust_cost_inflation_calc(N_eng*C_engine_base, 2012, target_year);

%% RTDE DAPCA RATES & COST

RE = adjust_cost_inflation_calc(115, DAPCA_base_year, target_year);  % Engineering rate
RT = adjust_cost_inflation_calc(118, DAPCA_base_year, target_year);  % Tooling rate
RM = adjust_cost_inflation_calc(98,  DAPCA_base_year, target_year);  % Manufacturing rate
RQ = adjust_cost_inflation_calc(108, DAPCA_base_year, target_year);  % Quality control rate

% Equations based on the provided image, all for MKS units
HE = (5.18  * W_e^0.777 * V_max^0.894 * Q^0.163) * fudge_factor_composite; % engineering hours
HT = (7.22  * W_e^0.777 * V_max^0.696 * Q^0.263) * fudge_factor_composite; % tooling hours
HM = (10.5  * W_e^0.820 * V_max^0.484 * Q^0.641) * fudge_factor_composite; % manufacturing hours
HQ = (0.133 * HM) * fudge_factor_composite; % quality contorl hours

HM_adj = learning_curve_95(HM, Q); % adjust for learning curve for manufacturing hours only, 95 % because we expect to see less improvement in newer programs
HQ_adj = learning_curve_95(HQ, Q); 

cost.RTDE_flyaway.engineering   = HE    *RE;
cost.RTDE_flyaway.tooling       = HT    *RT;
cost.RTDE_flyaway.manufacturing = HM_adj*RM;
cost.RTDE_flyaway.quality_ctrl  = HQ_adj*RQ;

%% Cost of development

CD_2012 = 67.400 * W_e^0.630 * V_max^1.3;               % development support cost
CF_2012 = 1974   * W_e^0.325 * V_max^0.822 * FTA^1.21;  % flight test cost
CM_2012 = 31.2   * W_e^0.921 * V_max^0.621 * Q^0.799;      % manufacturing materials cost

cost.RTDE_flyaway.development_support    = adjust_cost_inflation_calc(CD_2012, DAPCA_base_year, target_year);
cost.RTDE_flyaway.flight_test            = adjust_cost_inflation_calc(CF_2012, DAPCA_base_year, target_year);
cost.RTDE_flyaway.manufacturing_material = adjust_cost_inflation_calc(CM_2012, DAPCA_base_year, target_year);

% Loop to converge on avionics cost
tol = 1e-3;
converged = false;

cost_curr = 25000000000; % initial estimate of 25 billion

while converged == false
        
    cost.RTDE_flyaway.avionics = cost_curr*cost_avi_percent_flyaway;

    cost_new = cost.RTDE_flyaway.engineering + ...
               cost.RTDE_flyaway.tooling + ...       
               cost.RTDE_flyaway.manufacturing + ...
               cost.RTDE_flyaway.quality_ctrl + ...
               cost.RTDE_flyaway.development_support + ...
               cost.RTDE_flyaway.flight_test + ...
               cost.RTDE_flyaway.manufacturing_material + ...
               cost.RTDE_flyaway.engines + ...
               cost.RTDE_flyaway.avionics;

    if abs(cost_new - cost_curr) <= tol
        converged = true;
    end

    cost_curr = cost_new;
end

end