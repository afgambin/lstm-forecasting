function [struct_b2] = simulation_loop_b2(initial_batteryLevel, harvestedEnergy, trafficProfile, energy_prices, battery_max_level, days_simulation, hours_simulation, plotting)

fprintf('Computing Benchmark 2... \n');

array_batteryLevel_BS = initial_batteryLevel';

% Stats
array_average_batteryLevel = zeros(days_simulation,hours_simulation);
array_purchased_energy = zeros(days_simulation,hours_simulation);
array_cost = zeros(days_simulation,hours_simulation);

for day=1:days_simulation
    
    fprintf('Simulation day: %d \n', day);
    
    % Renewable energy pattern for each BS and each day
    array_BS_HE = harvestedEnergy.(['day' num2str(day)]);
    
    % Traffic profile for each BS and each day
    array_power_demand_BS = trafficProfile.(['day' num2str(day)]);
    
    % Traffic profile for each BS and each day
    array_SG_prices = energy_prices.(['day' num2str(day)]);
   
   % Trading is computed each hour 
   for hour=1:hours_simulation
       
       % Battery level update
       array_batteryLevel_BS = array_batteryLevel_BS - array_power_demand_BS(hour,:) + array_BS_HE(hour,:);
       array_batteryLevel_BS(array_batteryLevel_BS > battery_max_level) = battery_max_level;         
       
       % Benchmark 2 -> cover the expected demand
       indexes = array_batteryLevel_BS < 0;
    
       % Acquiring data      
       % Purchased energy
       array_purchased_energy(day,hour) = sum(abs(array_batteryLevel_BS(indexes)));
       
       % Cost
       array_cost(day,hour) = sum(abs(array_batteryLevel_BS(indexes)))*array_SG_prices(hour);
       
       % Battery level update after trading
       array_batteryLevel_BS(indexes) = 0;
            
       % Acquiring data - Battery      
       array_average_batteryLevel(day,hour) = mean(array_batteryLevel_BS);
                                     
   end
end

%%%%%%%%%%%%%%
% STATISTICS
%%%%%%%%%%%%%%

% Battery level
if(days_simulation == 1)
    daily_average_batteryLevel = array_average_batteryLevel;
else
    daily_average_batteryLevel = mean(array_average_batteryLevel);
end

if plotting
    figure, plot(daily_average_batteryLevel)
    title(['Daily BS EB level. Av: ', num2str(mean(daily_average_batteryLevel)),' Wh'])
    xlabel('Time (hours)')
    ylabel('EB level (Wh)')
    grid on
    axis tight;
end

% Purchased energy
if(days_simulation == 1)
    daily_average_purchased_energy = array_purchased_energy;
else
    daily_average_purchased_energy = mean(array_purchased_energy);
end

if plotting
    figure, plot(daily_average_purchased_energy)
    title(['Daily purchased energy. Av: ', num2str(mean(daily_average_purchased_energy)),' Wh'])
    xlabel('Time (hours)')
    ylabel('Energy (Wh)')
    grid on
    axis tight;
end

% Cost
if(days_simulation == 1)
    daily_average_cost = array_cost;
else
    daily_average_cost = mean(array_cost);
end

if plotting
    figure, plot(daily_average_cost)
    title(['Daily energy cost. Av: ', num2str(mean(daily_average_cost)),' cents'])
    xlabel('Time (hours)')
    ylabel('Cents')
    grid on
    axis tight;
end

% Outputs
struct_b2.battery = daily_average_batteryLevel;
struct_b2.purchased = daily_average_purchased_energy;
struct_b2.cost = daily_average_cost;

end
