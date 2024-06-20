
    
function dydt = hybridODE(t, y, net)
    % mu = net(y); % the parameters determined by the ANN %y is 4x1 double, how can that be when ode15s returns 16x4 double??
    k_d = 0.097426185;
    Y_xs = 0.688103094;
    Y_xco2 = 0.999999966;
 
    mu = net(y);
    % Y_xs_inv = params(2);
    % Y_xco2_inv = params(3);
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
    Substrate_dot = (F_in./Volume).*(S_in-Substrate)- mu/Y_xs;
    CO2_dot = mu/Y_xco2-q_air.*CO2;
    
    % Save differential equation in output vector
    dydt = [Volume_dot; Biomass_dot; Substrate_dot; CO2_dot];
end
