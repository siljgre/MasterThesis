load DataInterp_exp2_2_hours tspan sol
t = tspan(27:end,:); x = sol(27:end,:);

load DataInterp_exp2_2_hours_phase2_SMOOTH.mat tspan sol
ts = tspan; xs = sol;


plotSubplotsCompactAll(t,ts,x,xs)

function plotSubplotsCompactAll(t_exp1, t_exp2, y_exp1, y_exp2)
% tiles = tiledlayout(2,4,'TileSpacing','Compact','Padding','Compact');
tiles = tiledlayout(2,4,'TileSpacing','compact','Padding','loose');
% set(gcf, 'Position',  [100, 100, 900, 900]);

% figure
nexttile([1,2])
% Shade the area between data points of exp1 and exp2
hold on
box on
plot(t_exp1, y_exp1(:,2),'.-')
plot(t_exp2, y_exp2(:,2),'.-')
xlabel('Time [h]')
ylabel('X [g/L]')

nexttile([1,2])
hold on
box on
plot(t_exp1, y_exp1(:,3),'.-')
plot(t_exp2, y_exp2(:,3),'.-')
xlabel('Time [h]')
ylabel('S [g/L]')

nexttile([1,1])
axis off
nexttile([1,2])
hold on
box on
plot(t_exp1, y_exp1(:,4),'.-')
plot(t_exp2, y_exp2(:,4),'.-')
xlabel('Time [h]')
ylabel('CO_2 [%]')

leg = legend('Non-smoothed data', 'Smoothed data','Location','northoutside','orientation','horizontal');
leg.Position(1) = 0.27;
leg.Position(2) = 0.95;
% leg.FontSize = 12;

% sgtitle('Hybrid model and training data')

end
