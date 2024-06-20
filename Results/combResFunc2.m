function [RMSEphasetab,RMSEexptab,meanRMSE,meanRMSEvec] = combResFunc(outputs,modelphase1,modelphase2,exp1,exp2)
% Load hybrid model phase1
load(modelphase1,'t','y')
y(y<0)=0; %hybridmodellen gir neg output iblant
t1 = t; y1=y;

% Load hybrid model phase 2
load(modelphase2,'t','y')
y(y<0)=0; %hybridmodellen gir neg output iblant
t2 = t; y2 = y;

% Load experimental data
load(exp1,'tspan','sol')
t_exp1 = tspan;
y_exp1 = sol;

load(exp2,'tspan','sol')
t_exp2 = tspan;
y_exp2 = sol;

t = [t1; t2];
y = [y1; y2];

% plotSepPlots(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
% plotSubplotsCompact(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
plotSubplotsCompactAll(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
folder = 'resFiles';
figname= string(outputs)+'_trainingDataResAll.png';
saveas(gcf, fullfile(folder,figname));

[meanRMSE,RMSEexp1,RMSEexp2,meanRMSEvec] = rmseRelCalc(t, y, t_exp1, t_exp2, y_exp1, y_exp2); %relative rmse for each exp (vectors) and rel rmse in total (scalar)

[~,~,~,RMSEphase1] = rmseRelCalc(t1, y1, t_exp1(1:17), t_exp2(1:24), y_exp1(1:17,:), y_exp2(1:24,:)); 
[~,~,~,RMSEphase2] = rmseRelCalc(t2, y2, t_exp1(21:end), t_exp2(27:end), y_exp1(21:end,:), y_exp2(27:end,:));

RMSEphase = [RMSEphase1;RMSEphase2;(RMSEphase1+RMSEphase2)/2];
RMSEphasetab = table(RMSEphase,'RowNames',{'Phase 1';'Phase 2';'Mean'});

RMSEexp = [RMSEexp1;RMSEexp2;(RMSEexp1+RMSEexp2)/2];
RMSEexptab = table(RMSEexp,'RowNames',{'Exp 1';'Exp 2';'Mean'});
end