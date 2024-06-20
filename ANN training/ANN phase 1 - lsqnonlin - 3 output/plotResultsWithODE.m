clear
load poslin_10_10_7.mat t y t_exp1 t_exp2 y_exp1 y_exp2

par1 = param();
par2 = origParam(); %using the parameters from project thesis

y01 = y_exp1(2,:);
tspan1 = t_exp1(:);
[t_ode1,y_ode1] = ode15s(@(t, y) originalODE(t, y, par1), tspan1, y01);

y02 = y_exp2(1,:);
tspan2 = t_exp2(:);
[t_ode2,y_ode2] = ode15s(@(t, y) originalODE(t, y, par2), tspan2, y02);


% plotSubplots(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
% plotSepPlots(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
plotSubplotsWithODE(t, y, t_exp1, t_exp2, y_exp1, y_exp2,t_ode1,y_ode1,t_ode2,y_ode2)


function plotSepPlots(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
% Create vertices for patch
x_patch2 = [t_exp1; flipud(t_exp2)];
y_patch2 = [y_exp1(:,2); flipud(y_exp2(:,2))];
x_patch3 = [t_exp1; flipud(t_exp2)];
y_patch3 = [y_exp1(:,3); flipud(y_exp2(:,3))];
x_patch4 = [t_exp1; flipud(t_exp2)];
y_patch4 = [y_exp1(:,4); flipud(y_exp2(:,4))];

% Define color of patch
patchColor = [0.9 0.9 0.9];
% 
% % Plot
% figure
% hold on
% plot(t,y(:,1),LineWidth=0.6)
% plot(t_exp1, y_exp1(:,1),'.')
% plot(t_exp2, y_exp2(:,1),'.')
% ylim([0 2])
% legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of V')
% xlabel('Time [h]')
% ylabel('V [L]')

figure
patch(x_patch2, y_patch2, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,2),LineWidth=0.6)
plot(t_exp1, y_exp1(:,2),'.')
plot(t_exp2, y_exp2(:,2),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
title('Hybrid model vs experimental data of X')
xlabel('Time [h]')
ylabel('X [g/L]')

figure
patch(x_patch3, y_patch3, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,3),LineWidth=0.6)
plot(t_exp1, y_exp1(:,3),'.')
plot(t_exp2, y_exp2(:,3),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
title('Hybrid model vs experimental data of S')
xlabel('Time [h]')
ylabel('S [g/L]')

figure
patch(x_patch4, y_patch4, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,4),LineWidth=0.6)
plot(t_exp1, y_exp1(:,4),'.')
plot(t_exp2, y_exp2(:,4),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
title('Hybrid model vs experimental data of CO_2')
xlabel('Time [h]')
ylabel('CO_2 [%]')
end

function plotSubplots(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
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
subplot(2,2,1)
hold on
plot(t,y(:,1),LineWidth=0.6)
plot(t_exp1, y_exp1(:,1),'.')
plot(t_exp2, y_exp2(:,1),'.')
ylim([0 2])
legend('Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of V')
xlabel('Time [h]')
ylabel('V [L]')

subplot(2,2,2)
% Shade the area between data points of exp1 and exp2
patch(x_patch2, y_patch2, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,2),LineWidth=0.6)
plot(t_exp1, y_exp1(:,2),'.')
plot(t_exp2, y_exp2(:,2),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of X')
xlabel('Time [h]')
ylabel('X [g/L]')

subplot(2,2,3)
patch(x_patch3, y_patch3, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,3),LineWidth=0.6)
plot(t_exp1, y_exp1(:,3),'.')
plot(t_exp2, y_exp2(:,3),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of S')
xlabel('Time [h]')
ylabel('S [g/L]')

subplot(2,2,4)
patch(x_patch4, y_patch4, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,4),LineWidth=0.6)
plot(t_exp1, y_exp1(:,4),'.')
plot(t_exp2, y_exp2(:,4),'.')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of CO_2')
xlabel('Time [h]')
ylabel('CO_2 [%]')

sgtitle('Hybrid model vs experimental data')
end

function plotSubplotsWithODE(t, y, t_exp1, t_exp2, y_exp1, y_exp2,t_ode1,y_ode1,t_ode2,y_ode2)
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
subplot(2,2,1)
hold on
plot(t,y(:,1),LineWidth=0.6)
plot(t_exp1, y_exp1(:,1),'.')
plot(t_exp2, y_exp2(:,1),'.')
plot(t_ode1,y_ode1(:,1),'black--')
plot(t_ode2,y_ode2(:,1),'black--')
ylim([0 2])
legend('Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of V')
xlabel('Time [h]')
ylabel('V [L]')

subplot(2,2,2)
% Shade the area between data points of exp1 and exp2
patch(x_patch2, y_patch2, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,2),LineWidth=0.6)
plot(t_exp1, y_exp1(:,2),'.')
plot(t_exp2, y_exp2(:,2),'.')
plot(t_ode1,y_ode1(:,2),'black--')
plot(t_ode2,y_ode2(:,2),'black--')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of X')
xlabel('Time [h]')
ylabel('X [g/L]')

subplot(2,2,3)
patch(x_patch3, y_patch3, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,3),LineWidth=0.6)
plot(t_exp1, y_exp1(:,3),'.')
plot(t_exp2, y_exp2(:,3),'.')
plot(t_ode1,y_ode1(:,3),'black--')
plot(t_ode2,y_ode2(:,3),'black--')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of S')
xlabel('Time [h]')
ylabel('S [g/L]')

subplot(2,2,4)
patch(x_patch4, y_patch4, patchColor, 'FaceAlpha', 1, 'EdgeColor', 'none'); % Adjust transparency as needed
hold on
plot(t,y(:,4),LineWidth=0.6)
plot(t_exp1, y_exp1(:,4),'.')
plot(t_exp2, y_exp2(:,4),'.')
plot(t_ode1,y_ode1(:,4),'black--')
plot(t_ode2,y_ode2(:,4),'black--')
legend('','Hybrid model', 'Experiment 1', 'Experiment 2')
% title('Hybrid model vs experimental data of CO_2')
xlabel('Time [h]')
ylabel('CO_2 [%]')

sgtitle('Hybrid model vs experimental data')
end


function rmseCalc(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
    % Interpolate the ANN output t and y to match the times of each experiment and the ode, for the norm calculation
    y1= interp1(t, y, t_exp1, 'linear', 'extrap');
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');

    %calculating RMSE exp1
    RMSE1_V = rmse(y1(:,1),y_exp1(:,1));
    RMSE1_X = rmse(y1(:,2),y_exp1(:,2));
    RMSE1_S = rmse(y1(:,3),y_exp1(:,3));
    RMSE1_CO2 = rmse(y1(:,4),y_exp1(:,4));

    %calculating RMSE exp2
    RMSE2_V = rmse(y2(:,1),y_exp1(:,1));
    RMSE2_X = rmse(y2(:,2),y_exp1(:,2));
    RMSE2_S = rmse(y2(:,3),y_exp1(:,3));
    RMSE2_CO2 = rmse(y2(:,4),y_exp1(:,4));

   RMSE1_V+RMSE1_X+RMSE1_S+RMSE1_CO2+RMSE2_V+RMSE2_X+RMSE2_S+RMSE2_CO2

   RMSE1 = rmse(y1,y_exp1);
   RMSE2 = rmse(y2,y_exp2);
   % E = rmse(F,A)
   %If F-A is a matrix, then E is a row vector containing the RMSE for each column.

end


%%%% ode
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


function par = param()
    % these are estimated parameters for experiment 2:
    % par = [0.286069805	0.718103823	0.097426185	0.688103094	0.999999966];
    par = [0.28606964	0.681990685	0.09743177	0.688102544	0.999999966];

end

function par = origParam() %from project thesis
    par = [0.25266 2.6505 0.02169 0.4984 0.6047];
end
