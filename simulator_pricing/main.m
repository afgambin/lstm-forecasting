%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BS ENERGY TRADING - Automatic Simulator
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc, clear all, close all
%addpath('/home/afgambin/cvx/functions/vec_')

%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULATION PARAMETERS
%%%%%%%%%%%%%%%%%%%%%%%%%

N = 5;     % number of BSs (all of them are ongrid)
store = 0;      % save results  
alpha_HE_array = [1]; % controls amplitude in the harvested energy profile

% Battery model
e_max = 100;   %[W]         % energy buffer capacity
load_adjust_array = e_max*0.5;     %[0:0.05:1];    % controls amplitude in the traffic load profile

% Clusters to be tested
clusters = [1,5];   % 1 max - 2 min

pathFolder = [pwd '/results/cluster_12/'];

% HE randomness
shadowing_factor = 0; % uniform distribution between [-value, value]

for j=1:length(load_adjust_array)
    
    % Traffic load profiles
    array_power_demand_BS = generate_traffic_profile(N, e_max, load_adjust_array(j), clusters);
    
    for i=1:length(alpha_HE_array)
        % harvested energy profile
        array_BS_HE = generate_harvested_profile(N, shadowing_factor, e_max, alpha_HE_array(i));
        
        % call the main simulator function
        scenario(N, array_BS_HE, array_power_demand_BS, store, pathFolder, alpha_HE_array(i), load_adjust_array(j), e_max)
        
        % delete dataProfiles.mat
    end
end



