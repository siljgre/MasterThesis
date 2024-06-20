function [results, EXITFLAG] = param_est(initParams,loBound, upBound); 
sol=[0 0 0 0]; tspan = 0;

load DataInterp_exp2_hours.mat

% % % Before feeding
exp=sol(1:24,:); % [V X S CO2]
tspan = tspan(1:24);

% After feeding - must update initial conditions!
% exp=sol(27:end,:); % [V X S CO2]
% tspan = tspan(27:end);

opts = optimset('TolFun', 1e-12, 'TolX', 1e-12, 'MaxIter', 150, 'Diagnostics', 'off', 'Display', 'iter'); %original
[res, RESNORM,RESIDUAL,EXITFLAG] = lsqnonlin(@residual,  log10 (initParams), log10 (loBound), log10 (upBound), opts);
   
function R = residual(b)
        a = 10.^b;
        [T ,Y ] = reactionsolve (a);
        
        residual = exp - Y;
        R = residual(:);
        results=a;

        % Plotting
        subplot(3,1,2);
        plot(T,Y(:,2)); 
        hold on;
        plot(tspan(:,1),exp(:,2),'o'); 
        xlabel('Time');
        ylabel('Biomass');
        hold off;
        
        subplot(3,1,1);
        plot(T,Y(:,3)); 
        hold on;
        plot(tspan(:,1),exp(:,3),'o'); 
        xlabel('Time');
        ylabel('Substrate');
        hold off;
        str = sprintf('%g | ', a);
        title(str);
        
        subplot(3,1,3);
        plot(T,Y(:,4));
        hold on;
        plot(tspan(:,1),exp(:,4),'o');
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
    
    x0 = init_cond();
    [T,Y] = ode45(@reaction, tspan, x0, []);
    
    function dx = reaction(t, x)
        Volume = x(1);
        Biomass = x(2);
        Substrate = x(3);
        CO2 = x(4);
        
        Volume(Volume<0.00001) = 0.00001; %skjer hvis inni parantes er riktig
        Biomass(Biomass<0) = 0;
        Substrate(Substrate<0) = 0;
        CO2(CO2<0) = 0;        

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

    % x0 = sol(27,:); %(right after feeding)
    end

end
end


