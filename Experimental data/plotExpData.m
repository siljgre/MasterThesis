% Experiment 1
exp1XCO2 = 'DataOnline_exp1_hours.mat';
exp1S = 'HPLC_exp1_hours.mat';
% Experiment 2
exp2XCO2 = 'DataOnline_exp2_hours.mat';
exp2S = 'HPLC_exp2_2_hours.mat';

% Plot Exp1
plotSubplotsCompactAll(exp1XCO2,exp1S,'Experiment 1');
% plotAll(exp1XCO2,exp1S);
saveas(gcf, 'exp1plot2.png');

% Plot Exp2
plotSubplotsCompactAll(exp2XCO2,exp2S,'Experiment 2');
% plotAll(exp2XCO2,exp2S);
saveas(gcf, 'exp2plot2.png');


function plotSubplotsCompactAll(DataOnlinefile,HPLCfile,title)
    load(DataOnlinefile, 't','X_exp','CO2_exp');
    load(HPLCfile, 'tS', 'S_exp');
    tiles = tiledlayout(2,4,'TileSpacing','compact','Padding','compact');
    
    nexttile([1,2])
    hold on
    box on
    plot(t, X_exp, '-')
    ylabel('X [g/L]')
    xlabel('Time [h]')
    
    nexttile([1,2])
    hold on
    box on
    plot(tS, S_exp, '.-')
    ylabel('S [g/L]')
    xlabel('Time [h]')
    
    nexttile([1,1])
    axis off
    nexttile([1,2])
    hold on
    box on
    plot(t, CO2_exp)
    ylabel('CO_2 [%]')
    xlabel('Time [h]')
    
    sgtitle(title)
end

function plotAll(DataOnlinefile,HPLCfile)
    load(DataOnlinefile, 't','X_exp','CO2_exp');
    load(HPLCfile, 'tS', 'S_exp');
    
    figure
    plot(tS,S_exp,'.-')
    hold on
    plot(t,X_exp)
    plot(t,CO2_exp)
    % plot(t,V_exp)
    xlabel('Time [h]')
    ylabel('Concentration')
    legend('S [g/L]', 'X [g/L]', 'CO_2 [%]')
end 
