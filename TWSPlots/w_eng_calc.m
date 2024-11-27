% Aerosp 481 Group 3 - Libellula 
function [w_eng] = w_eng_calc(T_0)
% Description: This function generates a the engine weight. using Chapter
% 7.3.3 from metabook
% 
% INPUTS:
% --------------------------------------------
%    aircraft 
%    T_0 - maximum thrust of the engine, N
% 
% OUTPUTS:
% --------------------------------------------
%    w_eng_kg
% 
% See also: togw_regression_loop()
% Latest author:                   Niko
% Version history revision notes:
%                                  v1: 9/22/2024
    
    T_0_lbf = ConvForce(T_0, 'N', 'lbf');

    w_eng_dry     = 0.521*(T_0_lbf)^0.9;
    w_eng_oil     = 0.082*(T_0_lbf)^0.65;
    % w_eng_rev     = 0.034*(T_0_lbf); fighters do not usually have thrust reversers
    w_eng_control = 0.260*(T_0_lbf)^0.5;
    w_eng_start   = 9.330*(w_eng_dry/1000)^1.078;

    w_eng_lb = w_eng_dry + w_eng_oil + w_eng_control + w_eng_start; %[lbf]

    w_eng = ConvMass(w_eng_lb, 'lbm', 'kg');
    
end