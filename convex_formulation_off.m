clc, clear all
addpath('/home/afgambin/cvx/functions/vec_')

N = 10;                              % number of BSs
N_on = 7;
N_off = N-N_on;
decimals = 5;

% E = repmat(randi(20, 1, N_on), N_off, 1);   % Energy matrix
% p = randi(15, N_on, 1);                % energy prices
% d = randi(40, N_off, 1);
load('notEnough.mat')

a = 0.7; % Scalarization factor
relaxed_bound = 0.75;   % 15%
x = rand(N_off,N_on);

if (sum(E(1,:)) - sum(d)) >= 0
    
    fprintf('Enough energy to cover the demand... \n');
    
    %cvx_solver sedumi
    cvx_begin quiet
    variable x(N_off,N_on)
    minimize( sum(E.*x*p) )
    subject to
    0 <= x <= 1
    0 <= sum(x) <= 1
    sum(E.*x,2) - d >= 0
    cvx_end
    
else
    
    fprintf('Not enough energy to cover the demand... \n');
    
    cvx_begin quiet
    variable x(N_off,N_on)
    minimize( a*(sum(E.*x*p)) + (1-a)*((sum(sum(E.*x,2) - d))^2) )
    subject to
    0 <= x <= 1
    0 <= sum(x) <= 1
    %sum(sum(E.*x,2)) >= relaxed_bound*sum(d)
    cvx_end
    
end

x = round(x,decimals)
energy_available = E(1,:)
energy_demand = d'
prices = p'

