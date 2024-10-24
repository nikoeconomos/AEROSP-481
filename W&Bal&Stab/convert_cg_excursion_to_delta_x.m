function delta_x_cg = convert_cg_excursion_to_delta_x(cg_excursion_arr)
% Description: Plugging in a cg excurion calc array from
% cg_excursion_calc.m, get the delta x
% 
% 
% INPUTS:
% --------------------------------------------
%    cg_excursion_calc -- array of cg locations over an excursion
% 
% OUTPUTS:
% --------------------------------------------
%    delta_x_cg
%                       
% 
% See also: 
% script
% Author:                          Niko
% Version history revision notes:
%                                  v1: 10/24/24    

    %% FOR EASE %%

    x0 = cg_excursion_arr(1);

    delta_x_cg = zeros(length(cg_excursion_arr), 1);
    for i = 2:length(cg_excursion_arr)
        delta_x_cg(i) = cg_excursion_arr(i,1)-x0;
    end

end