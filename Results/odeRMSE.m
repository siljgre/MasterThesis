function [RMSEode,meanRelODEvec] = ODErmse(exp1,exp2)
exp1 = load(exp1);
exp2 = load(exp2);
t_exp1 = exp1.tspan; y_exp1 = exp1.sol;
t_exp2 = exp2.tspan; y_exp2 = exp2.sol;

% Phase 1
par1 = [0.72815676	1.069704479	0.435185161	1.596612687	2.421610953]; %MC PHASE 2 bounds, 1_3_phase2 

y0 = init_cond();
tspan = [0 9.5];
[t_ode1,y_ode1] = ode15s(@(t, y) originalODE(t, y, par1), tspan, y0);

% Phase 2
par2 = [1.680780247	10	0.003959245	0.80574189	1.6293062]; %estimated with MC, bounds phase 2
y0 = [(y_exp1(21,1)+y_exp2(27,1))/2 (y_exp1(21,2)+y_exp2(27,2))/2 (y_exp1(21,3)+y_exp2(27,3))/2 (y_exp1(21,4)+y_exp2(27,4))/2]; %using the mean of the 2 experiments as initial cond in ode model
tspan = [10 21];
[t_ode2,y_ode2] = ode15s(@(t, y) originalODE(t, y, par2), tspan, y0);

% Concatinating ode solution
t_ode = [t_ode1; t_ode2];
y_ode = [y_ode1; y_ode2];

[RMSEode,~,~,meanRelODEvec] = rmseRelCalc(t_ode, y_ode, t_exp1, t_exp2, y_exp1, y_exp2); %the mean relative RMSE

% % Interpolate ODE output
% y1_ode = interp1(t_ode, y_ode, t_exp1, 'linear', 'extrap');
% y2_ode = interp1(t_ode, y_ode, t_exp2, 'linear', 'extrap');
% 
% % Calculate RMSE
% RMSEode1 = rmse(y1_ode,y_exp1);
% RMSEode2 = rmse(y2_ode,y_exp2);
% RMSEode = sum(RMSEode1) + sum(RMSEode2);

plotSubplotsCompactAllODE(t_ode,y_ode,t_exp1, t_exp2, y_exp1, y_exp2)
folder = 'resFiles';
figname= 'ODE.png';
saveas(gcf, fullfile(folder,figname));

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



function plotSubplotsCompactAllODE(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
% tiles = tiledlayout(2,4,'TileSpacing','Compact','Padding','Compact');
tiles = tiledlayout(2,4,'TileSpacing','compact','Padding','loose');
% set(gcf, 'Position',  [100, 100, 900, 900]);

% figure
% Create vertices for patch
x_patch2 = [t_exp1; flipud(t_exp2)];
y_patch2 = [y_exp1(:,2); flipud(y_exp2(:,2))];
x_patch3 = [t_exp1; flipud(t_exp2)];
y_patch3 = [y_exp1(:,3); flipud(y_exp2(:,3))];
x_patch4 = [t_exp1; flipud(t_exp2)];
y_patch4 = [y_exp1(:,4); flipud(y_exp2(:,4))];

% Define color of patch
patchColor = [0.9 0.9 0.9];

% Plot
% nexttile
% hold on
% box on
% plot(t,y(:,1),LineWidth=0.6)
% plot(t_exp1, y_exp1(:,1),'.')
% plot(t_exp2, y_exp2(:,1),'.')
% ylim([0 2])
% xlim([0 22])
% xlabel('Time [h]')
% ylabel('V [L]')

nexttile([1,2])
% Shade the area between data points of exp1 and exp2
patch(x_patch2, y_patch2, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
box on
plot(t,y(:,2),LineWidth=0.6)
plot(t_exp1, y_exp1(:,2),'.')
plot(t_exp2, y_exp2(:,2),'.')
xlim([0 22])
xlabel('Time [h]')
ylabel('X [g/L]')

nexttile([1,2])
patch(x_patch3, y_patch3, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
box on
plot(t,y(:,3),LineWidth=0.6)
plot(t_exp1, y_exp1(:,3),'.')
plot(t_exp2, y_exp2(:,3),'.')
xlim([0 22])
xlabel('Time [h]')
ylabel('S [g/L]')

nexttile([1,1])
axis off
nexttile([1,2])
patch(x_patch4, y_patch4, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
box on
plot(t,y(:,4),LineWidth=0.6)
plot(t_exp1, y_exp1(:,4),'.')
plot(t_exp2, y_exp2(:,4),'.')
xlim([0 22])
xlabel('Time [h]')
ylabel('CO_2 [%]')

% leg = legend('','Hybrid model', 'Experiment 1', 'Experiment 2','Location','eastoutside','orientation','vertical');
% leg.Position(1) = 0.75;
% leg.Position(2) = 0.25;
leg = legend('','ODE model', 'Experiment 1', 'Experiment 2','Location','northoutside','orientation','horizontal');
leg.Position(1) = 0.22;
leg.Position(2) = 0.95;
% leg.FontSize = 12;

% sgtitle('Hybrid model and training data')
end



% function plotSubplotsODE(t_exp1, t_exp2, y_exp1, y_exp2,t_ode,y_ode)
% figure
% % Create vertices for patch
% x_patch2 = [t_exp1; flipud(t_exp2)];
% y_patch2 = [y_exp1(:,2); flipud(y_exp2(:,2))];
% x_patch3 = [t_exp1; flipud(t_exp2)];
% y_patch3 = [y_exp1(:,3); flipud(y_exp2(:,3))];
% x_patch4 = [t_exp1; flipud(t_exp2)];
% y_patch4 = [y_exp1(:,4); flipud(y_exp2(:,4))];
% 
% % Define color of patch
% patchColor = [0.9 0.9 0.9];
% 
% % Plot
% subplot(2,2,1)
% hold on
% plot(t_exp1, y_exp1(:,1),'.')
% plot(t_exp2, y_exp2(:,1),'.')
% plot(t_ode,y_ode(:,1),'black--')
% ylim([0 2])
% legend('Hybrid model', 'Experiment 1', 'Experiment 2')
% % title('Hybrid model vs experimental data of V')
% xlabel('Time [h]')
% ylabel('V [L]')
% 
% subplot(2,2,2)
% % Shade the area between data points of exp1 and exp2
% patch(x_patch2, y_patch2, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
% hold on
% plot(t_exp1, y_exp1(:,2),'.')
% plot(t_exp2, y_exp2(:,2),'.')
% plot(t_ode,y_ode(:,2),'black--')
% legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% % title('Hybrid model vs experimental data of X')
% xlabel('Time [h]')
% ylabel('X [g/L]')
% 
% subplot(2,2,3)
% patch(x_patch3, y_patch3, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
% hold on
% plot(t_exp1, y_exp1(:,3),'.')
% plot(t_exp2, y_exp2(:,3),'.')
% plot(t_ode,y_ode(:,3),'black--')
% legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% % title('Hybrid model vs experimental data of S')
% xlabel('Time [h]')
% ylabel('S [g/L]')
% 
% subplot(2,2,4)
% patch(x_patch4, y_patch4, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
% hold on
% plot(t_exp1, y_exp1(:,4),'.')
% plot(t_exp2, y_exp2(:,4),'.')
% plot(t_ode,y_ode(:,4),'black--')
% legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% % title('Hybrid model vs experimental data of CO_2')
% xlabel('Time [h]')
% ylabel('CO_2 [%]')
% 
% sgtitle('Hybrid model vs experimental data')
% 
% folder = 'resFiles';
% figname= 'ODE.png';
% saveas(gcf, fullfile(folder,figname));
% end

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
