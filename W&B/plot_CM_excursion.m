clear
close all
clc

% Generate CG Envelope/Excursion Plot 

% Define wieght and CG locations for different phases of flight

% Define a matrix (flight data) where each row represents a differen
%t phase and each column represents [ weight (kg, CG location (MAC
%fraction) ]

cannon = aircraft.weight.m61a1;
drum = aircraft.weight.m61a1_feed_system;
engine = aircraft.weight.engine;
one = aircraft.weight.togw; % empty weight
two = aircraft.weight.fuel_weight; %fuel weight 
three = aircraft.weight.missile*2; % [kg] payload 1 weight 
four = aircraft.weight.missile*2; % [kg] payload 2 weight
five = aircraft.weight.missile*2; % [kg] playload 3 weight 
six = aircraft.weight.m61a1_ammo; % [kg] cannon rounds

% CG Location along %MAC
xcg_cannon = 7.124;
xcg_drum = 7.5445;
xcg_engine = 14.33;
xcg_one = ;
xcg_two= ;
xcg_three = 8.065;
xcg_four = 8.065;
xcg_five = 8.065;

 
%Loading Configurations 1-9
weight_config_1 = [
    one, xcg_one;
    two, xcg_two;
    three, xcg_three;
    four, xcg_four;
    five, xcg_five;
 ];

weight_config_2 = [
    one, xcg_one;
    three, xcg_three;
    four, xcg_four;
    two, xcg_two;
    five, xcg_five;   
];

weight_config_3 = [
    one, xcg_one;
    three, xcg_three;
    four, xcg_four;
    two, xcg_two;
    five,xcg_five;
 ];

weight_config_4 = [
    one, xcg_one;
    three, xcg_three;
    two, xcg_two;
    four, xcg_four;
    five_xcg_five; 
 ];

weight_config_5 = [
    one, xcg_one;
    three, xcg_three;
    four, xcg_four;
    two, xcg_two;
 ];

weight_config_6 = [
    one, xcg_one;
    two, xcg_two;
    three, xcg_three;
    four, xcg_four;
 ];

weight_config_7 = [
    one, xcg_one;
    three, xcg_three;
    two, xcg_two;
    four, xcg_four;  
 ];

weight_config_8 = [
    one, xcg_one;
    two, xcg_two;
    three, xcg_three;
 ];

weight_config_9 = [
    one, xcg_one;
    three, xcg_three;
    two, xcg_two;
 ];

weight_config_10 = [
    one, xcg_one;
    two, xcg_two;
 ];


% seperating weignt and CG data
weight_1 = wigth_config_1(:,1); 
cg_location_1 = weigth_config_1(:,2);

weight_2 = wigth_config_2(:,1); 
cg_location_2 = weigth_config_2(:,2);

weight_3 = wigth_config_3(:,1); 
cg_location_3 = weigth_config_3(:,2);

weight_4 = wigth_config_4(:,1); 
cg_location_4 = weigth_config_4(:,2);

weight_5 = wigth_config_5(:,1); 
cg_location_5 = weigth_config_5(:,2);

weight_6 = wigth_config_6(:,1); 
cg_location_6 = weigth_config_6(:,2);

weight_7 = wigth_config_7(:,1); 
cg_location_7 = weigth_config_7(:,2);

weight_8 = wigth_config_8(:,1); 
cg_location_8 = weigth_config_8(:,2);

weight_9 = wigth_config_9(:,1); 
cg_location_9 = weigth_config_9(:,2);

weight_10 = wigth_config_10(:,1); 
cg_location_10 = weigth_config_10(:,2);


% Plotting the CG excursion
figure;
hold on
plot(cg_location_1, weight_1, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 1
hold on
plot(cg_location_2, weight_2, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 2
hold on
plot(cg_location_3, weight_3, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 3
hold on
plot(cg_location_4, weight_4, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 4
hold on
plot(cg_location_5, weight_5, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 5
hold on
plot(cg_location_6, weight_6, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 6
hold on
plot(cg_location_7, weight_7, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 7
hold on
plot(cg_location_8, weight_8, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 8
hold on
plot(cg_location_9, weight_9, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 9
hold on
plot(cg_location_10, weight_10, '-o', 'LineWidth', 2); % Plot CG location vs weight for Config 10
CG location vs weight for Config 13
xlabel('CG Location (% MAC)');
ylabel('Weight (kg)');
title('CG Excursion Plot');
grid on;

% Add annotations for flight phases
flight_phases = {'', '', '', '', ...
                 '', '', '', ''};














% Add text annotations to the plot at each point
%for i = 1:length(cg_location)
%    text(cg_location(i), weight(i), flight_phases{i}, 'VerticalAlignment','bottom','HorizontalAlignment','right');
%end