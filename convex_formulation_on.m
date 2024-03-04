clc, clear all
%addpath('/home/afgambin/cvx/functions/vec_')

N = 10;                            % Number of BSs
N_on = 3;
N_off = N - N_on;
decimals = 5;

e_max = 100;
e = randi(50, 1, N_on);            % Energy battery level array
p = randi(15, N_on, 1);            % SG energy prices
d =  randi(100, 1, N_on);          % Energy demand

%cvx_solver sedumi
cvx_begin quiet
variable x(1,N_on)
minimize( sum(e_max*x*p) )
subject to
0 <= x <= 1
e_max*x +e -d >= 0
cvx_end

x = round(x,decimals)
energy_demand = d
prices = p'

