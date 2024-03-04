clc, clear all
addpath('/home/afgambin/cvx/functions/vec_')

N = 5;                              % number of BSs
E = randi(5, 1, N);                % Energy matrix
p = randi(20, N, 1);                % energy prices
d = randi(50, 1, 1);

a = 0.5; % Scalarization factor
x = rand(1,N);


%cvx_solver sedumi
cvx_begin quiet
    variable x(1,N)
    minimize( a*((E.*x)*p) + (1-a)*((sum(E.*x) - d)^2) )
    subject to                                                              
        0 <= x <= 1
        %sum(x) <= 1
        %sum(E.*x) - d >= 0
cvx_end

x
p

