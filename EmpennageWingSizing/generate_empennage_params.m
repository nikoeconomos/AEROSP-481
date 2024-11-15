function [aircraft] = generate_empennage_params(aircraft)
% Description:
% Generates parameters that describe our empennage
%
% INPUTS:
% --------------------------------------------
%    aircraft
%
% OUTPUTS:
% --------------------------------------------
%    
%    aircraft
%
% 
% Author:                          Juan
% Version history revision notes:
%                                  v2: 11/15/2024


    %%%%%%%%%%%%
    %% H TAIL %%
    %%%%%%%%%%%%

    aircraft.geometry.htail.AR = 4; % DECIDED

    % for convenience
    htail = aircraft.geometry.htail;

    htail.lever_arm = 0.5 * aircraft.geometry.fuselage.length; % TODO: originally L_F, CONFIRM this is fuselage; lever arm distance between CoM and MAC of horizontal stabilizer 
    
    htail.b = sqrt( htail.AR * htail.S_ref);

    htail.c_root = 1.2755; % m DECIDED
    htail.taper_ratio = 0.5;

    htail.c_tip = htail.c_root*htail.taper_ratio;

    htail.volume_coefficient = 0.4;  % Raymer decision

    htail.sweep_LE = deg2rad(49.9); % radians 
    htail.sweep_QC = atan( tan(htail.sweep_LE) - (4 / htail.AR) * ((0.25 * (1 - htail.taper_ratio)) / (1 + htail.taper_ratio)) ); % formula from aerodynamics slide 24
    
    htail.S_ref = htail.volume_coefficient * aircraft.geometry.wing.MAC * aircraft.geometry.wing.S_ref  / htail.lever_arm; % TODO CONFIRM WHETHER THIS IS 1 section or both
    htail.S_wet = 2*htail.S_ref; %m2 APPROXIMATION, UPDATE WITH A BETTER ONE

    htail.xRLE = 15.208; % m position of leading edge of the root chord, from CAD, from nose tip


    %%%%%%%%%%%%
    %% V TAIL %%
    %%%%%%%%%%%%

    aircraft.geometry.vtail.AR = 2; % TODO: UPDATE / STATE WHERE IT WAS GOTTEN FROM

    % for convenience
    vtail = aircraft.geometry.vtail;

    vtail.lever_arm = htail.lever_arm + 0.4; % TODO UPDATE / STATE WHERE IT WAS GOTTEN FROM

    vtail.b = sqrt(vtail.AR * vtail.S_ref);

    vtail.c_root = 1.3815;
    vtail.taper_ratio = 0.35;

    vtail.c_tip = vtail.c_root*vtail.taper_ratio;   

    vtail.volume_coefficient = 0.07; % Raymer decision 

    vtail.S_ref = vtail.volume_coefficient * aircraft.geometry.wing.b * aircraft.geometry.wing.S_ref / vtail.lever_arm; % TODO CONFIRM AND STATE LOCATION OF EQUATION
    vtail.S_wet = 2*vtail.S_ref; %m2 APPROXIMATION, UPDATE WITH A BETTER ONE

    vtail.sweep_LE = deg2rad(55); % radians
    
    vtail.xRLE = 15.191; %m same as htail TODO UPDATE IF NECESSARY   
    
    
end