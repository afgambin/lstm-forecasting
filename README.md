# Smart Energy Policies for Sustainable Mobile Networks via Forecasting and Adaptive Control

The design of sustainable mobile networks is key to reduce their impact on the environment, and to diminish their operating cost. As a solution to this, this project advocates Energy Harvesting (EH) Base Stations (BSs) that collect energy from the environment, use it to serve the local traffic and/or store it in a battery for later use. Moreover, whenever the amount of energy harvested is insufficient to serve their traffic load, BSs purchase energy from the power grid. 

Within this setup, a smart energy management strategy is devised with the goal of diminishing the cost incurred in the energy purchases. This is achieved by intelligently controlling the amount of energy that BSs buy from the electrical grid over time, by accounting for the harvested energy, the traffic load, and hourly energy prices. The proposed optimization framework combines pattern forecasting and adaptive control. In a first stage, harvested energy and traffic load processes are modeled through a Long Short-Term Memory (LSTM) neural network, allowing each BS to independently predict future energy and load patterns. LSTM-based forecasts are then fed into an adaptive control block, where foresighted optimization is performed using Model Predictive Control (MPC).

Numerical results, obtained with real-world energy and load signals, show cost savings close to 20% and reductions in the
amount of energy purchased from the electrical grid of about 24%, with respect to a heuristic scheme where future system
states are not taken into account.

This is the code repository of the project. You can find more information about it here: https://ieeexplore.ieee.org/document/8644112
