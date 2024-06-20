clear

for i = 1:5
    i
filename = strcat('1o2_tansig_10_10',num2str(i)); %save to file
tic 

par = param();
load expdata\DataInterp_exp2_2_hours_SMOOTH.mat tspan sol
t_exp2 = tspan(27:end,:);
y_exp2 = sol(27:end,:);

load expdata\DataInterp_exp1_hours_phase2AdditionalData_SMOOTH.mat tspan sol
t_exp1 = tspan;
y_exp1 = sol;

tspan = [10 21];
y0 = [(y_exp1(1,1)+y_exp2(1,1))/2 (y_exp1(1,2)+y_exp2(1,2))/2 (y_exp1(1,3)+y_exp2(1,3))/2 (y_exp1(1,4)+y_exp2(1,4))/2]; %using the mean of the 2 experiments as initial cond in ode model
[t_ode, y_ode] = ode15s(@(t, y) originalODE(t, y, par), tspan, y0);

%% Set up the Neural Network.
net_mu = feedforwardnet([10 10]); %hidden layer size
net_mu.inputs{1}.size = 4; % input are the states 
net_mu.layers{end}.size = 1; % output is the parameter

net_mu.layers{end}.transferFcn = 'tansig'; %tansig, logsig, poslin, softmax

initialWeights_mu = getwb(net_mu);
initialWeights_mu = randn(size(initialWeights_mu)) * 0.1;

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
% shadowplot(t,y,t_exp1,t_exp2,y_exp1,y_exp2,t_ode,y_ode)
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
    
function cost = computeCost(weights, net, tspan, y0, y_exp1, y_exp2,y_ode,t_exp1,t_exp2,t_ode)
    % Update the ANN with the current weight
    net = setwb(net, weights);
    % Solve hybrid model
    [t, y] = ode15s(@(t, y) hybridODE(t, y, net), tspan, y0);

    % Interpolate the ANN output t and y to match the times of each experiment and the ode, for the norm calculation
    y1= interp1(t, y, t_exp1(1:21,:), 'linear', 'extrap'); %vil ikkje ha brå knekk der funksjonen går til å kun passe exp1..
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');

    cost1 = (y1-y_exp1(1:21,:));
    cost2 = (y2-y_exp2);
    cost = [cost1; cost2];
end

function par = param()
    par = [0.656070462	1.327542312	0.004927512	1.113490688	2.139437985];
end

function plotting(t_exp1,y_exp1,t_exp2,y_exp2,t,y)
    figure
    plot(t_exp1, y_exp1, 'b.');
    hold on
    plot(t_exp2, y_exp2,'b.');
    plot(t, y,'r');
    xlabel('Time');
    ylabel('y(t)');
    title('Hybrid ODE-ANN Model with 1 Optimized Parameter');
end