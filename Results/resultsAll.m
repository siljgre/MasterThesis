clear
% Define the path to this folder
thisFolder = 'C:\Users\silje\NTNU\Master - Code\Results';
% Define the experimental data
exp1 = "expdata\DataInterp_exp1_hours.mat";
exp2 = "expdata\DataInterp_exp2_2_hours_SMOOTH.mat";

[RMSEode,meanRMSEode] = odeRMSE(exp1,exp2);

%% 1 output
% Find hybrid model with lowest cost (in each phase) and save it to this folder
folder1 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 1 - lsqnonlin - 1 output\results';
file1 = copyminCostFile(folder1,thisFolder);

folder2 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 2 - lsqnonlin - 1 output\results';
file2 = copyminCostFile(folder2,thisFolder);

[poslin1,tansig1,logsig1] = saveHypSearchRes(folder1);
cd(thisFolder)
[poslin2,tansig2,logsig2] = saveHypSearchRes(folder2);
cd(thisFolder)

[poslin1time,tansig1time,logsig1time] = saveHypSearchResTimeOnly(folder1);
cd(thisFolder)
[poslin2time,tansig2time,logsig2time] = saveHypSearchResTimeOnly(folder2);
cd(thisFolder)

filename = '1output.mat';
folder = 'resFiles';
save(fullfile(folder,filename),'poslin1','tansig1','logsig1','poslin2','tansig2','logsig2','poslin1time','tansig1time','logsig1time','poslin2time','tansig2time','logsig2time')

[RMSE1phase,RMSE1exp,meanRMSE1,meanRMSE1vec] = combResFunc2('1output',file1,file2,exp1,exp2); %this the RMSE in each state (summed exp1 and exp2 deviation)

%% 2 output
folder1 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 1 - lsqnonlin - 2 output\results';
file1 = copyminCostFile(folder1,thisFolder);

folder2 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 2 - lsqnonlin - 2 output\results';
file2 = copyminCostFile(folder2,thisFolder);

[poslin1,tansig1,logsig1] = saveHypSearchRes(folder1);
cd(thisFolder)
[poslin2,tansig2,logsig2] = saveHypSearchRes(folder2);
cd(thisFolder)

[poslin1time,tansig1time,logsig1time] = saveHypSearchResTimeOnly(folder1);
cd(thisFolder)
[poslin2time,tansig2time,logsig2time] = saveHypSearchResTimeOnly(folder2);
cd(thisFolder)

filename = '2output.mat';
folder = 'resFiles';

save(fullfile(folder,filename),'poslin1','tansig1','logsig1','poslin2','tansig2','logsig2','poslin1time','tansig1time','logsig1time','poslin2time','tansig2time','logsig2time')

[RMSE2phase,RMSE2exp,meanRMSE2,meanRMSE2vec] = combResFunc2('2output',file1,file2,exp1,exp2);

%% 3 output
folder1 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 1 - lsqnonlin - 3 output\results';
file1 = copyminCostFile(folder1,thisFolder);

folder2 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 2 - lsqnonlin - 3 output\results';
file2 = copyminCostFile(folder2,thisFolder);


[poslin1,tansig1,logsig1] = saveHypSearchRes(folder1);
cd(thisFolder)
[poslin2,tansig2,logsig2] = saveHypSearchRes(folder2);
cd(thisFolder)

[poslin1time,tansig1time,logsig1time] = saveHypSearchResTimeOnly(folder1);
cd(thisFolder)
[poslin2time,tansig2time,logsig2time] = saveHypSearchResTimeOnly(folder2);
cd(thisFolder)

filename = '3output.mat';
folder = 'resFiles';
save(fullfile(folder,filename),'poslin1','tansig1','logsig1','poslin2','tansig2','logsig2','poslin1time','tansig1time','logsig1time','poslin2time','tansig2time','logsig2time')

[RMSE3phase,RMSE3exp,meanRMSE3,meanRMSE3vec] = combResFunc2('3output',file1,file2,exp1,exp2);

%% 4 output
folder1 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 1 - lsqnonlin - 4 output\results';
file1 = copyminCostFile(folder1,thisFolder);

folder2 = 'C:\Users\silje\NTNU\Master - Code\ANN training\ANN phase 2 - lsqnonlin - 4 output\results';
file2 = copyminCostFile(folder2,thisFolder);


[poslin1,tansig1,logsig1] = saveHypSearchRes(folder1);
cd(thisFolder)
[poslin2,tansig2,logsig2] = saveHypSearchRes(folder2);
cd(thisFolder)

[poslin1time,tansig1time,logsig1time] = saveHypSearchResTimeOnly(folder1);
cd(thisFolder)
[poslin2time,tansig2time,logsig2time] = saveHypSearchResTimeOnly(folder2);
cd(thisFolder)

filename = '4output.mat';
folder = 'resFiles';
save(fullfile(folder,filename),'poslin1','tansig1','logsig1','poslin2','tansig2','logsig2','poslin1time','tansig1time','logsig1time','poslin2time','tansig2time','logsig2time')

[RMSE4phase,RMSE4exp,meanRMSE4,meanRMSE4vec] = combResFunc2('4output',file1,file2,exp1,exp2);

%% Save RMSE results
save(fullfile(folder,filename),'poslin1','tansig1','logsig1','poslin2','tansig2','logsig2','poslin1time','tansig1time','logsig1time','poslin2time','tansig2time','logsig2time')

%% Function definitions
function file = copyminCostFile(folder,thisFolder)
    file = minCostFile(folder);
    copyfile(file, thisFolder)
    cd(thisFolder)
end

