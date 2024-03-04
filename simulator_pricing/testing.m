clc, clear all, close all
E_max = 100;
load('mpc_test')
hour = 1;
E0_array = [-125];
%%%

for h=1:hour
    for bs=1:length(E0_array)
        E0 = E0_array(bs);
        M = 24; % horizon
        p = array_SG_prices; % SG energy prices -> cent/Wh
        E_max_matrix = E_max*ones(1,M);
        %safety_th = 0.1*E_max;
        
        % Constraints
        u_max_0 = E_max - E0;
        u_max = [u_max_0 E_max*ones(1,M-1)]; % max Power
        u_min = zeros(1,M); % min Power
        
        aux = array_BS_HE' - (array_power_demand_BS*0.5)';    % disturbance considering daily profile (from hour 1)
        disturbance = [aux(:, hour:end) aux(:, 1:(hour-1))];    % disturbance starting from current time slot
        aux(aux >0) = 0;
        E_min_matrix = abs(aux);
        
        %cvx_solver gurobi
        cvx_begin
        
        variables u(1,M) E(1,M)
        
        minimize( sum(sum(p.*u)) )
        
        subject to
        
        E == [E0 E(1:(M-1))] + u + disturbance;
        
        % Energy buffer constraints:
        E_min_matrix <= E <= E_max_matrix;
        
        % Actuator limits
        %u_min <= u <= u_max;
        
        cvx_end
        
        figure, plot(u(1,:), '-*b')
        hold on
        plot(E(1,:), '-xr')
        hold on
        plot(p*10000, '-ok')
        hold on
        plot(disturbance,'-+g')
        xlabel('Time (hours)')
        grid on
        legend('Purchased energy', 'Energy buffer level', 'Energy price (c€/Wh)', 'Disturbance')
        axis tight;
        
        current_action = u(1); % MPC strategy performs the first control decision every step
    end
    
end


