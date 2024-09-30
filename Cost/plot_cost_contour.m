function [] = plot_cost_contour(aircraft)
    T = linspace(0,300000,200);
    S = linspace(0,60,200);
    [Tgrid,Sgrid] = meshgrid(T,S);
    Cost = cost_as_func_of_T_S(aircraft,Tgrid,Sgrid);
    contour(Sgrid,Tgrid,Cost);
end