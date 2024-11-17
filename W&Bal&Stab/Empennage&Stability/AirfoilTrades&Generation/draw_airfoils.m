% Aerosp 481 Group 3 - Libellula 
function [biconvex_export, hexagonal_export] = draw_airfoils()
% Description: Draws airfoils based on ..?
% 
% 
% INPUTS:
% --------------------------------------------
%    none
% 
% OUTPUTS:
% --------------------------------------------
%    airfoil exports
%                       
% 
% See also: None
% Author:                          Juan
% Version history revision notes:
%                                  v1: ?


%% Setup

chord_panels = 26;
norm_chord    = linspace(0,1,chord_panels);

N = 10; %Change this to change airfoil front roundness

del_panel = norm_chord(2)-norm_chord(1);
r = N*del_panel;
d_theta = pi/(2*N);

%% Biconvex airfoil coordinates
T_to_C = 0.033;

% biconvex_top = zeros(0,length(norm_chord));
% for i = 1:length(norm_chord)
% 
%     if i <= N
%         theta = pi - d_theta*(i-1);
%         biconvex_top(i) = r*sin(theta);
%     else
%         biconvex_top(i) = 2 * T_to_C * (-norm_chord(i)^2 + norm_chord(i));
%     end
% 
% end

biconvex_top = 2 * T_to_C * (-norm_chord.^2 + norm_chord);

biconvex_bottom      = -biconvex_top;
biconvex_bottom(1)   = 0;
biconvex_bottom(end) = 0;

biconvex_export = transpose([fliplr(biconvex_top),biconvex_bottom]);
biconvex_mfoil  = transpose([biconvex_top,fliplr(biconvex_bottom)]);

% Plot airfoil
figure()
subplot(1,2,1)
plot(norm_chord, biconvex_top)
hold on
plot(norm_chord, biconvex_bottom)
title('Biconvex Airfoil');
xlabel('Normalized Chord');
ylabel('Thickness');
axis equal


%% Hexagonal airfoil coordinates 
%  using same thickness to chord ratio as biconvex airfoil and flat surface staing at 0.25c and ending at 0.75c

hexagonal_top = zeros(0,length(norm_chord));

% Unused sizing method
% for i = 1:length(norm_chord)
% 
%     if i <= N
%         theta = pi - d_theta*(i-1);
%         hexagonal_top(i) = r*sin(theta);
%     elseif N < i && i <= 25
%         hexagonal_top(i) = 2*T_to_C*norm_chord(i);
%     elseif i > 25 && i <= 75
%         hexagonal_top(i) = T_to_C/2;
%     else
%         hexagonal_top(i) = -2*T_to_C*norm_chord(i) + 2*T_to_C;
%     end
% 
% end

for i = 1:length(norm_chord)
    if i <= round(chord_panels/4)
        hexagonal_top(i) = 2*T_to_C*norm_chord(i);
    elseif i > round(chord_panels/4) && i <= 3*round(chord_panels/4)
        hexagonal_top(i) = T_to_C/2;
    else
        hexagonal_top(i) = -2*T_to_C*norm_chord(i) + 2*T_to_C;
    end
end

hexagonal_bottom      = -hexagonal_top;
hexagonal_bottom(1)   = 0;
hexagonal_bottom(end) = 0;

hexagonal_export = transpose([fliplr(hexagonal_top),hexagonal_bottom]);
hexagonal_mfoil  = transpose([hexagonal_top,fliplr(hexagonal_bottom)]);

% Plot hexagonal airfoil
subplot(1,2,2)
plot(norm_chord, hexagonal_top)
hold on
plot(norm_chord, hexagonal_bottom)
title('Hexagonal Airfoil');
xlabel('Normalized Chord');
ylabel('Thickness');
axis equal

%%%%%%%%%%%%%%%%%%%
%% Export points %%
%%%%%%%%%%%%%%%%%%%

norm_chord_export = transpose([fliplr(norm_chord),norm_chord]);
norm_chord_mfoil  = transpose([norm_chord,fliplr(norm_chord)]);

biconvex_export       = [norm_chord_export, biconvex_export];
biconvex_export(27,:) = [];

hexagonal_export       = [norm_chord_export, hexagonal_export];
hexagonal_export(27,:) = [];

biconvex_mfoil       = [norm_chord_export, biconvex_mfoil];
biconvex_mfoil(27,:) = [];
biconvex_mfoil(26,2) = biconvex_mfoil(25,2);

hexagonal_mfoil       = [norm_chord_export, hexagonal_mfoil];
hexagonal_mfoil(27,:) = [];
hexagonal_mfoil(26,2) = hexagonal_mfoil(25,2);