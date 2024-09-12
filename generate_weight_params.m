% Aerosp 481 Group 3 - Libellula 
function [weight_params] = generate_weight_params()
% Description: This function generates a struct that holds parameters used in
% calculating the initial weight estimate of our aircraft
% 
% 
% INPUTS:
% --------------------------------------------
%    a - [m,n] size,[double] type,Description
%    b - [m,n] size,[double] type,Description
%    c - [m,n] size,[double] type,Description
% 
% OUTPUTS:
% --------------------------------------------
%    weight_params - X element struct, contains:
%                       a_jet_fighter = asdf
%                       asdf
% 
% See also: None
% Author:                          Niko
% Version history revision notes:
%                                  v1: 9/10/2024

    % ------------------------ REGRESSION CONSTANTS  ------------------------------------

    % A constant for metric units, assuming jet fighter, it is closest to our design. 
    % For weight estimation regression.
    % Pulled from Raymer table 3.1
    % Assuming conventional metallic structure will be used
    weight_params.a_jet_fighter = 2.11; % [Unitless][metric]
    
    % C constant, assuming jet fighter. For weight estimation regression
    % Pulled from Raymer table 3.1
    weight_params.c_jet_fighter = -0.13; % [Unitless]

    % ---------------------------------------- CREW ----------------------------------------

    % Average weight of crew member and carry on luggage given by the
    % metabook. No checked baggage included in this.
    weight_params.w_crew_member = 82; % [kg]

    % Number of crew members to include onboard [TODO update if remote piloting]
    weight_params.num_crew_members = 0; % [number]

    % Total weight of crew members. Crew weight * num of crew members
    % aboard
    weight_params.w_crew = weight_params.num_crew_members*weight_params.w_crew_member; % [kg]

    % ---------------------------------------- PAYLOAD  --------------------------------------

    % Weight of the missile we are tasked with using, 327 lb from RFP
    weight_params.w_aim120 = 148.325; %[kg]

    % Number of missiles aboard the plane when taking off
    weight_params.num_aim120 = 6; % [number]

    % Weight of the cannon we are tasked with using TODO if this value is
    % not ammo weight. 300 lbs from RFP
    weight_params.w_m61a1_feed_system = 136.078; %[kg]
    
    % Weight of all usable weapons systems aboard. Missile weight*num
    % missiles + weight of ammo
    weight_params.w_payload = weight_params.num_aim120*weight_params.w_aim120 + weight_params.w_m61a1_feed_system;%[lbs]

    % ---------------------------------------- EMPTY WEIGHT ----------------------------------

    % Weight of the cannon we are tasked with using, 275 from RFP
    weight_params.w_m61a1 = 124.738; %[kg]

    % A guess weight for the start of the togw calculation. The empty
    % weight of an F-35
    weight_params.w_0_guess = 13290; % [kg]

end