function [program_dt_and_e_cost, breakeven_upcharge] = dt_and_e_and_breakeven_cost_calc(aircraft)
% Description: This function generates a regression based cost estimate for
% the cost of the Design, Test, and Evaluation (DT&E) phase of the aircraft
% program as well as the ammount of added cost that should be passed on to the
% customer with each aircraft unit sold in order to break even with 60
% units 
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%     program_dt_and_e_cost - Double. Program DT&E phase cost estimate                
%     breakeven_upcharge - Double. Break even customer upcharge
%
% See also: generate_cost_params.m
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/16/2024

%% Constant Parameters %%
%%%%%%%%%%%%%%%%%%%%%%%%%

% Weight &
W = aircraft.weight.togw * 2.20462; %TOGW in [lbs], multiplied TOGW in kg with conversion factor to get value in lbs

% Quantity %
Qd = 3; % Number of aircraft produced during development phase, number is sually between 2-10 so selected 3 due to 
% cost restrictions and sizable industry knowledge on interceptor aircraft development 
Qp = 1000; % Number of aircraft produced for program duration (from RFP)
Q = Qd + Qp; % Total aircraft quantity produced during program

% Mission Requirements %
S = 277.821180117969 * 1.944; % Maximum aircraft speed at best altitude in [knots], used dash speed at 35,000 ft and 
% multiplied speed in m/s with conversion factor (1.944) to get value in knots 

% Inflation Adjustments %
target_year = 2024;
base_year = 1998;


%% Airframe Engineering Phase %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
airf_eng_hours = 4.86 * (W^0.777) * (S^0.894) * (Q^0.163); % [hr]
airframe_engineering_cost = airf_eng_hours * aircraft.labor.skunk_works_hourly_2024; % [2024 USD]



%% Development Support %%
%%%%%%%%%%%%%%%%%%%%%%%%%
dev_support_cost_1998 = 66 * (W^0.63) * (S^1.3); % [1998 USD]
dev_support_cost = apply_inflation(dev_support_cost_1998, base_year, target_year); % [2024 USD]



%% Flight Test Operations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flight_test_cost_1998 = 1852 * (W^0.325) * (S^0.822) * (Qd^1.21); % [1998 USD]
flight_test_cost = apply_inflation(flight_test_cost_1998, base_year, target_year); % [2024 USD]



%% Tooling %%
%%%%%%%%%%%%%
tooling_hours = 5.99 * (W^0.777) * (S^0.696) * (Q^0.263); % [hr]
tooling_cost = tooling_hours * aircraft.labor.tooling_hourly_2024; % [2024 USD]



%% Manufacturing Labor %%
%%%%%%%%%%%%%%%%%%%%%%%%%
manufacturing_hours = 7.37 * (W^0.82) * (S^0.484) * (Q^0.641); % [hr]
manufacturing_cost = manufacturing_hours * aircraft.labor.manufacturing_hourly_2024; % [2024 USD]



%% Quality Control %%
%%%%%%%%%%%%%%%%%%%%%
quality_control_cost = 0.13 * manufacturing_cost; % Typically 10-15% in aerospace manufacturing. This holds



%% Manufacturing Material & Equipment %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
manuf_mat_eq_cost_1998 = 16.39 * (W^0.921) * (S^0.621) * (Q^0.799); % [1998 USD]
manuf_mat_eq_cost = apply_inflation(manuf_mat_eq_cost_1998, base_year, target_year); % [2024 USD]



%% Overal Program Phase Cost %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
program_dt_and_e_cost = airframe_engineering_cost + dev_support_cost + flight_test_cost + tooling_cost + ...
manufacturing_cost + quality_control_cost + manuf_mat_eq_cost; % [2024 USD]

breakeven_upcharge = program_dt_and_e_cost/60; % [2024 USD]

end