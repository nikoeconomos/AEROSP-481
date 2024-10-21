clear
close all
clc
AR = 3.068;
S_W = 36;
b_W = sqrt(AR*S_W);

lambda = 0.35; % taper ratio
c_root_W = 2*S_W / ( (1+lambda) * b_W);
c_tip_W = lambda * c_root_W;
c_bar_W = 2*c_root_W*((1 + lambda + lambda^2)/(1 + lambda))/3; % [m]

Y_bar = b_W * ((1 + 2*lambda) / (1 + lambda)) /6;

L_F = 16.3;
L_HT = 0.5 * L_F;
L_VT = L_HT + 0.4;

c_VT = 0.07;
c_HT = 0.4;
S_VT = c_VT * b_W * S_W / L_VT;

S_one_VT = S_VT/2;
S_HT = c_HT * c_bar_W * S_W / L_HT;
S_one_HT = S_HT/2;

gamma_vtail = atand(S_VT/S_HT); % degrees

To_thrust = 57.8e3;

yt = 0.8;

Nt_crit = To_thrust*yt;
Nt_drag = Nt_crit*0.15;
Nt_tot = Nt_drag + Nt_crit;

% Vertical Tail Dimensions
b_VT = sqrt(AR*S_one_VT);
b_VT_one = b_VT/2;
c_root_VT = 2*S_one_VT / ( (1+lambda) * b_VT);
c_tip_VT = lambda * c_root_VT;
c_bar_VT = 2*c_root_VT*((1 + lambda + lambda^2)/(1 + lambda))/3;
Y_bar = b_VT * ((1 + 2*lambda) / (1 + lambda)) /6;

% b_VT = sqrt(AR*S_VT);
% b_VT_one = b_VT/2;
% 
% c_root_VT = 2*S_VT / ( (1+lambda) * b_VT);
% c_tip_VT = lambda * c_root_VT;
% c_bar_VT = 2*c_root_VT*((1 + lambda + lambda^2)/(1 + lambda))/3;
% 
% Y_bar_VT = b_VT * ((1 + 2*lambda) / (1 + lambda)) /6;

% Horizontal Tail Dimensions
b_HT = sqrt(AR*S_one_HT);
b_HT_one = b_HT/2;
c_root_HT = 2*S_one_HT / ( (1+lambda) * b_HT);
c_tip_HT = lambda * c_root_HT;
c_bar_HT = 2*c_root_HT*((1 + lambda + lambda^2)/(1 + lambda))/3;
Y_bar_HT = b_HT * ((1 + 2*lambda) / (1 + lambda)) /6;
%% Draw Airfoils
chord_pannels = 26;
norm_chord = linspace(0,1,chord_pannels);
N = 10; %Change this to change airfol front roundness
del_pannel = norm_chord(2)-norm_chord(1);
r = N*del_pannel;
d_theta = pi/(2*N);
% Biconvex airfoil coordinates
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
biconvex_bottom = -biconvex_top;
biconvex_bottom(1) = 0;
biconvex_bottom(end) = 0;
biconvex_export = transpose([fliplr(biconvex_top),biconvex_bottom]);
biconvex_mfoil = transpose([biconvex_top,fliplr(biconvex_bottom)]);
figure()
subplot(1,2,1)
plot(norm_chord, biconvex_top)
hold on
plot(norm_chord, biconvex_bottom)
title('Biconvex Airfoil');
xlabel('Normalized Chord');
ylabel('Thickness');
axis equal
% Hexagonal airfoil coordinates using same thickness to chord ratio as
% biconvex airfoil and flat surface staing at 0.25c and ending at 0.75c
hexagonal_top = zeros(0,length(norm_chord));
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
    if i <= round(chord_pannels/4)
        hexagonal_top(i) = 2*T_to_C*norm_chord(i);
    elseif i > round(chord_pannels/4) && i <= 3*round(chord_pannels/4)
        hexagonal_top(i) = T_to_C/2;
    else
        hexagonal_top(i) = -2*T_to_C*norm_chord(i) + 2*T_to_C;
    end
end
hexagonal_bottom = -hexagonal_top;
hexagonal_bottom(1) = 0;
hexagonal_bottom(end) = 0;
hexagonal_export = transpose([fliplr(hexagonal_top),hexagonal_bottom]);
hexagonal_mfoil = transpose([hexagonal_top,fliplr(hexagonal_bottom)]);
subplot(1,2,2)
plot(norm_chord, hexagonal_top)
hold on
plot(norm_chord, hexagonal_bottom)
title('Hexagonal Airfoil');
xlabel('Normalized Chord');
ylabel('Thickness');
axis equal
% Export points
norm_chord_export = transpose([fliplr(norm_chord),norm_chord]);
norm_chord_mfoil = transpose([norm_chord,fliplr(norm_chord)]);
biconvex_export = [norm_chord_export, biconvex_export];
biconvex_export(27,:) = [];
hexagonal_export = [norm_chord_export, hexagonal_export];
hexagonal_export(27,:) = [];
biconvex_mfoil = [norm_chord_export, biconvex_mfoil];
biconvex_mfoil(27,:) = [];
biconvex_mfoil(26,2) = biconvex_mfoil(25,2);
hexagonal_mfoil = [norm_chord_export, hexagonal_mfoil];
hexagonal_mfoil(27,:) = [];
hexagonal_mfoil(26,2) = hexagonal_mfoil(25,2);