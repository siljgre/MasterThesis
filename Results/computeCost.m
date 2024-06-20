function cost = computeCost(weights, net, tspan, y0, y_exp1, y_exp2,y_ode,t_exp1,t_exp2,t_ode)
    % Update the ANN with the current weight
    net = setwb(net, weights);
    % Solve hybrid model
    [t, y] = ode15s(@(t, y) hybridODE(t, y, net), tspan, y0);

    % Interpolate the ANN output t and y to match the times of each experiment and the ode, for the norm calculation
    y1= interp1(t, y, t_exp1, 'linear', 'extrap'); %vil ikkje ha brå knekk der funksjonen går til å kun passe exp1..
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');

    cost1 = (y1-y_exp1);
    cost2 = (y2-y_exp2);
    cost = [cost1; cost2];
end