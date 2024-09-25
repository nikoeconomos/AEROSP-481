function [constants] = generate_constants()
% Description: 
% 
% This function is to calculate the different parameters 
% (TSFC, range, flight velocity) needed for the ESCORT_mission 
% fuel fraction calculation (in ESCORT_fuel_fraction_calc.m). Each paramter
% is calculated according to the mission segment (takeoff, climb, dash,
% escort, cruise, decent, reserve) that correspond with the ESCORT mission
% description in the RFP.
%
% INPUTS:
% --------------------------------------------
%    NO INPUT VALUES
%
% OUTPUTS:
% --------------------------------------------
%    constants - 2 layer struct.
%    Contains constants for general use throughout the entire project
% 
% See also: 
%
% Author:                          Juan
% Version history revision notes:
%                                  v1: 9/11/2024

constants.r_air = 287.05; % Gas constant for air [J/kg*K]

constants.tsfc_conversion = 1/7938; % Conversion factor for TSFC | multiply by it to convert TSFC from lbm/(lbf*h) 
% to kgm/(kgf*s)

end