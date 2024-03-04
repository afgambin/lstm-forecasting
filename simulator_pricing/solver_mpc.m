function [current_action] = solver_mpc(E_max, E0, array_BS_HE, array_power_demand_BS, hour, array_SG_prices)

% E_max -> battery_max_level
% E0 -> battery Level array of L
% array_BS_HE -> harvested energy for L
% array_power_demand_BS -> traffic load for L
% hour -> current time slot
% array_prices -> SG energy prices


% debug
% clc, clear all, close all
% E_max = 100;
% E0 = 0;
% load('mpc_test')
% hour = 24;
%%%

M = 24; % horizon
p = array_SG_prices; % SG energy prices -> cent/Wh
E_max_matrix = E_max*ones(1,M);
alpha = 0.5;
E_ref = 0.1*E_max;

% Constraints
% u_max_0 = E_max - E0;
% u_max = [u_max_0 E_max*ones(1,M-1)]; % max Power
u_min = zeros(1,M); % min Power

aux = array_BS_HE' - array_power_demand_BS';    % disturbance considering daily profile (from hour 1)
disturbance = [aux(:, hour:end) aux(:, 1:(hour-1))];    % disturbance starting from current time slot
aux(aux >0) = 0;
E_min_matrix = abs(aux); 

%cvx_solver gurobi
cvx_begin quiet

    variables u(1,M) E(1,M)
    
    minimize( alpha*(sum(sum(p.*u))) + (1-alpha)*sum(sum((E - E_ref).^2)) )
    
    subject to   
    
        E == [E0 E(1:(M-1))] + u + disturbance;

        % Energy buffer constraints:
        E_min_matrix <= E <= E_max_matrix;
        
        % Actuator limits
        u_min <= u %<= u_max;
     
cvx_end

% figure, plot(u(1,:), '-*b')
% hold on
% plot(E(1,:), '-xr')
% hold on
% plot(p*10000, '-ok')
% hold on
% plot(disturbance,'-+g')
% xlabel('Time (hours)')
% grid on
% legend('Purchased energy', 'Energy buffer level', 'Energy price (c€/Wh)', 'Disturbance')
% axis tight;

% if u(1) < 0
%     current_action = 0;
% else
%     current_action = u(1); % MPC strategy performs the first control decision every step
% end

current_action = u(1); % MPC strategy performs the first control decision every step

end