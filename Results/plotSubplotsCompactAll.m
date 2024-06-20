function plotSubplotsCompactAll(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
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
leg = legend('','Hybrid model', 'Experiment 1', 'Experiment 2','Location','northoutside','orientation','horizontal');
leg.Position(1) = 0.22;
leg.Position(2) = 0.95;
% leg.FontSize = 12;

% sgtitle('Hybrid model and training data')

end
