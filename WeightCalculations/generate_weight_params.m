% Aerosp 481 Group 3 - Libellula 
function [aircraft] = generate_weight_params(aircraft)
% Description: This function generates a struct for the weights of aircraft
% using various helper methods
% 
% 
% INPUTS:
% --------------------------------------------
%    aircraft - aircraft struct with specs
% 
% OUTPUTS:
% --------------------------------------------
%    aircraft - aircraft param with struct, updated with weight
%    parameters
%                       
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/14/2024

%% Weight Calculations %%
%%%%%%%%%%%%%%%%%%%%%%%%%%

aircraft.weight.ff = ff_total_calc(aircraft);

[togw,w_empty] = togw_and_w_empty_calc(aircraft);

aircraft.weight.togw = togw;
aircraft.weight.empty = w_empty;
aircraft.weight.fuel = aircraft.weight.ff*aircraft.weight.togw;

end