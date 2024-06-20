function dydt = hybridODE(t, y, net)
    params = net(y);
    mu = params(1);
    Y_xs_inv = params(2);
    Y_xco2_inv = params(3);
    k_d = params(4);
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
