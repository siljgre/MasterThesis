% Interpolating online measurements to match times of HPLC measurements
% (fewer data points).

% Not including feeding
% param_est([0.1;0.1;0.1;0.1;0.1], [0 0.001 0.001 0 0], [1 5 1 2 5])

function [results, EXITFLAG] = param_est(initParams,loBound, upBound); 
sol=[0 0 0 0]; tspan = 0;

load DataInterp_exp1_hours.mat
% Before feeding
exp1=sol(1:17,:); % [V X S CO2]
tspan1 = tspan(1:17);
% After feeding
% exp1 = sol(21:end,:);
% tspan1 = tspan(21:end);

load DataInterp_exp2_hours.mat 
% Before feeding
exp2=sol(1:24,:); % [V X S CO2]
tspan2 = tspan(1:24);
% After feeding
% exp2 = sol(27:end,:);
% tspan2 = tspan(27:end);


opts = optimset('TolFun', 1e-12, 'TolX', 1e-12, 'MaxIter', 150, 'Diagnostics', 'off', 'Display', 'iter'); %original
% opts = optimset('TolFun', 1e-12, 'TolX', 1e-12, 'MaxIter', 150,'Algorithm', 'levenberg-marquardt', 'Diagnostics', 'off', 'Display', 'iter'); %not original
% opts = optimset('TolFun', 1e-8, 'TolX', 1e-12, 'MaxIter', 100, 'Diagnostics', 'off', 'Display', 'iter');

[res, RESNORM,RESIDUAL,EXITFLAG] = lsqnonlin(@residual,  log10 (initParams), log10 (loBound), log10 (upBound), opts);
   
function R = residual(b)
        a = 10.^b;
        [T ,Y ] = reactionsolve (a);
   
        y1= interp1(T, Y, tspan1, 'linear', 'extrap'); 
        y2= interp1(T, Y, tspan2, 'linear', 'extrap');

        cost1 = (y1-exp1);
        cost2 = (y2-exp2);
        cost = [cost1; cost2];
        residual = cost;

        
        
        R = residual(:);
        results=a;

        % Plotting
        subplot(3,1,2);
        plot(T,Y(:,2)); 
        hold on;
        plot(tspan1(:,1),exp1(:,2),'o'); 
        plot(tspan2(:,1),exp2(:,2),'o'); 
        xlabel('Time');
        ylabel('Biomass');
        hold off;
        
        subplot(3,1,1);
        plot(T,Y(:,3)); 
        hold on;
        plot(tspan1(:,1),exp1(:,3),'o'); 
        plot(tspan2(:,1),exp2(:,3),'o'); 
        xlabel('Time');
        ylabel('Substrate');
        hold off;
        str = sprintf('%g | ', a);
        title(str);
        
        subplot(3,1,3);
        plot(T,Y(:,4));
        hold on;
        plot(tspan1(:,1),exp1(:,4),'o');
        plot(tspan2(:,1),exp2(:,4),'o'); 
        xlabel('Time');
        ylabel('CO2');
        hold off;
        
        hold off;
        drawnow;
end

function [ T, Y ] = reactionsolve( a )
    par.mu_max = a(1);
    par.K_s = a(2);
    par.k_d = a(3);
    par.Y_xs = a(4);
    par.Y_xco2 = a(5);
    
    % After feeding
    x0 = [(exp1(1,1)+exp2(1,1))/2 (exp1(1,2)+exp2(1,2))/2 (exp1(1,3)+exp2(1,3))/2 (exp1(1,4)+exp2(1,4))/2]; %using the mean of the 2 experiments as initial cond in ode model
        
    % Before feeding
    % x0 = init_cond();
    [T,Y] = ode45(@reaction, tspan2, x0, []);
    
    function dx = reaction(t, x)
        Volume = x(1);
        Biomass = x(2);
        Substrate = x(3);
        CO2 = x(4);
        
        Volume(Volume<0.00001) = 0.00001; %skjer hvis inni parantes er riktig
        Biomass(Biomass<0) = 0;
        Substrate(Substrate<0) = 0;
        CO2(CO2<0) = 0;        
        % % Stop emptying the tank when the tank is empty, to ensure that volume does
        % % not reach negative values
        % if Volume == 0.00001
        %    par.F_out = 0;
        % end

        %%%%%%%%%%%%%%%%%%%%
        % Parameters: Do not change
        par.F_in = 0;
        par.F_out = 0;
        par.S_in = 100;
        par.q_air = 2;
        %%%%%%%%%%%%%%%%%%%%
        
        % Model equations
        Volume_dot = par.F_in;
        Biomass_dot = -(par.F_in./Volume).*Biomass+par.mu_max.*(Substrate./(par.K_s+Substrate)).*Biomass-par.k_d.*Biomass;
        Substrate_dot = (par.F_in./Volume).*(par.S_in-Substrate)-(par.mu_max).*Substrate./((par.K_s+Substrate)).*(Biomass./par.Y_xs);
        CO2_dot = par.mu_max.*(Substrate./(par.K_s+Substrate)).*(Biomass./par.Y_xco2)-par.q_air.*CO2;
        
        dx = zeros(4,1);
        dx(1)=Volume_dot;
        dx(2)=Biomass_dot;
        dx(3)=Substrate_dot;
        dx(4)=CO2_dot;   
    end

    function x0 = init_cond()
    % Define initial conditions
    Volume_0 = 1; %L
    Biomass_0 = 1.2; % g/L
    Substrate_0 = 10; % g/L
    CO2_0 = 0; % percent  

    % Save all initial conditons in one vector
    x0 = [Volume_0; Biomass_0; Substrate_0; CO2_0];

    % x0 = sol(21,:); %(right after feeding)
    end

end
end


