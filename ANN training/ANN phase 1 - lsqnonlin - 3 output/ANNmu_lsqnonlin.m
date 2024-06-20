clear

for i = 9:10
    i
filename = strcat('1_3_tansig_5_5_',num2str(i)); %save to file
tic 

par = param();
load expdata\DataInterp_exp2_hours.mat tspan sol
t_exp2 = tspan(1:24,:);
y_exp2 = sol(1:24,:);

load expdata\DataInterp_exp1_hours.mat tspan sol
t_exp1 = tspan(1:17,:);
y_exp1 = sol(1:17,:);

tspan = [0 9.5];
y0 = init_cond();
[t_ode, y_ode] = ode15s(@(t, y) originalODE(t, y, par), tspan, y0);

%% Set up the Neural Network.
net_mu = feedforwardnet([5 5]); %hidden layer size
net_mu.inputs{1}.size = 4; % input are the states 
net_mu.layers{end}.size = 3; % output is the parameter

net_mu.layers{end}.transferFcn = 'tansig';

initialWeights_mu = getwb(net_mu);
initialWeights_mu = randn(size(initialWeights_mu)) * 0.1; % Get initial weights and biases of the ANN

% Define the cost function
costFunction = @(weights) computeCost(weights, net_mu, tspan, y0, y_exp1, y_exp2, y_ode,t_exp1,t_exp2,t_ode);

% Minimize cost function
options = optimoptions('lsqnonlin', 'Display', 'iter'); 
optimalWeights_mu = lsqnonlin(costFunction, initialWeights_mu, [], [], [], [], [], [], [], options); 

% Update the ANN with the optimal weights
net_mu = setwb(net_mu, optimalWeights_mu);
 
% Solve the ODE using the optimized ANN
[t, y] = ode15s(@(t, y) hybridODE(t, y, net_mu), tspan, y0);

%% Plot the results
plotting(t_exp1,y_exp1,t_exp2,y_exp2,t,y)
time=toc;
save(strcat('results\',filename))

end

%% %%%% Function definitions %%%%&

function dydt = originalODE(t, y, par)
    % Unpacking parameters
    mu_max = par(1);
    K_s = par(2);
    k_d = par(3);
    Y_xs = par(4);
    Y_xco2 = par(5);
  
    % System inputs
    F_in = 0;
    S_in = 100; %constant
    q_air = 2; %constant 2L/min. Shouldn't it be 120 [L/h] since everything else is in h^-1?

    % Unpacking states
    Volume = y(1);
    Biomass = y(2);
    Substrate = y(3);
    CO2 = y(4);
    
    % Ensure positive states
    Volume(Volume<0.00001) = 0.00001;
    Biomass(Biomass<0) = 0;
    Substrate(Substrate<0) = 0;
    CO2(CO2<0) = 0;
    
    % Define differential equation
    Volume_dot = F_in;
    Biomass_dot = -(F_in./Volume).*Biomass+mu_max.*(Substrate./(K_s+Substrate)).*Biomass-k_d.*Biomass;
    Substrate_dot = (F_in./Volume).*(S_in-Substrate)-(mu_max).*Substrate./((K_s+Substrate)).*(Biomass./Y_xs);
    CO2_dot = mu_max.*(Substrate./(K_s+Substrate)).*(Biomass./Y_xco2)-q_air.*CO2;
    
    % Save differential equation in output vector
    dydt = [Volume_dot; Biomass_dot; Substrate_dot; CO2_dot]; 
end
    
function dydt = hybridODE(t, y, net)
    % mu = net(y); % the parameters determined by the ANN %y is 4x1 double, how can that be when ode15s returns 16x4 double??
    k_d = 0.097426185;
    % Y_xs = 0.688103094;
    % Y_xco2 = 0.999999966;
 
    params = net(y);
    mu = params(1);
    Y_xs_inv = params(2);
    Y_xco2_inv = params(3);
    % k_d = 0.097426185; %phase1

    % System inputs
    F_in = 0; %constant
    S_in = 100; %constant
    q_air = 2; %constant

    % Unpacking states
    Volume = y(1);
    Biomass = y(2);
    Substrate = y(3);
    CO2 = y(4);

    % Ensure positive states
    Volume(Volume<0.00001) = 0.00001; 
    Biomass(Biomass<0) = 0;
    Substrate(Substrate<0) = 0;
    CO2(CO2<0) = 0;

    Volume_dot = F_in;
    Biomass_dot = -(F_in./Volume).*Biomass + mu - k_d.*Biomass;
    Substrate_dot = (F_in./Volume).*(S_in-Substrate)- mu*Y_xs_inv;
    CO2_dot = mu*Y_xco2_inv-q_air.*CO2;
    
    % Save differential equation in output vector
    dydt = [Volume_dot; Biomass_dot; Substrate_dot; CO2_dot];
end

function cost = computeCost(weights, net, tspan, y0, y_exp1, y_exp2,y_ode,t_exp1,t_exp2,t_ode)
    % Update the ANN with the current weight
    net = setwb(net, weights);
    % Solve hybrid model
    [t, y] = ode15s(@(t, y) hybridODE(t, y, net), tspan, y0);

    % Interpolate the ANN output t and y to match the times of each experiment and the ode, for the norm calculation
    y1= interp1(t, y, t_exp1, 'linear', 'extrap'); %vil ikkje ha brå knekk der funksjonen går til å kun passe exp1..
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');
    % y3= interp1(t, y, t_ode, 'linear', 'extrap');

    cost1 = (y1-y_exp1);
    cost2 = (y2-y_exp2);
    cost = [cost1; cost2];
end

function par = param()
    par = [0.286069805	0.718103823	0.097426185	0.688103094	0.999999966];
end

function x0 = init_cond()
    % Define initial conditions
    Volume_0 = 1; %L
    Biomass_0 = 1.2; % g/L
    Substrate_0 = 10; % g/L
    CO2_0 = 0; % percent
    x0 = [Volume_0 Biomass_0 Substrate_0 CO2_0]; %1x4 double
end

function plotting(t_exp1,y_exp1,t_exp2,y_exp2,t,y)
    figure
    plot(t_exp1, y_exp1, 'black.');
    hold on
    plot(t_exp2, y_exp2,'b.');
    plot(t, y,'r');
    xlabel('Time');
    ylabel('y(t)');
    title('Hybrid ODE-ANN Model with 1 Optimized Parameter');
end
