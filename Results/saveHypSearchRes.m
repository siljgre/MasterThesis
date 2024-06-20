% Legg til lagring av tid for kvar
% saveHypSearchResult('C:\Users\silje\NTNU\10 Master\ANN\10 gL sugar\Train and test\ANN phase 2 - lsqnonlin - 2 output')

function [poslin,tansig,logsig] = saveHypSearchRes(folder)
cd(folder)
% Iterate through all files
matFiles = dir('*.mat');

% Define empty arrays for RRMSE for each hyperparameter combination
poslin_5_rrmse = [];
poslin_5_5_rrmse = [];
poslin_10_rrmse = [];
poslin_10_10_rrmse = [];

tansig_5_rrmse = [];
tansig_5_5_rrmse = [];
tansig_10_rrmse = [];
tansig_10_10_rrmse = [];

logsig_5_rrmse = [];
logsig_5_5_rrmse = [];
logsig_10_rrmse = [];
logsig_10_10_rrmse = [];

for k = 1:length(matFiles)
    file = matFiles(k).name;
    f = load(file);

    % get activation function and hidden layer structure
    [~,~,key] = actFunAndStruct(f);

    % calculate relative RMSE
    rrmse = rmseRelCalc(f.t, f.y, f.t_exp1, f.t_exp2, f.y_exp1, f.y_exp2);

    if strcmp(key,'poslin_5')
        poslin_5_rrmse = [poslin_5_rrmse; rrmse];
    elseif strcmp(key,'poslin_5_5')
        poslin_5_5_rrmse = [poslin_5_5_rrmse; rrmse];
    elseif strcmp(key,'poslin_10')
        poslin_10_rrmse = [poslin_10_rrmse; rrmse];
    elseif strcmp(key,'poslin_10_10')
        poslin_10_10_rrmse = [poslin_10_10_rrmse; rrmse];
 
    elseif strcmp(key,'logsig_5')
        logsig_5_rrmse = [logsig_5_rrmse; rrmse];
    elseif strcmp(key,'logsig_5_5')
        logsig_5_5_rrmse = [logsig_5_5_rrmse; rrmse];
    elseif strcmp(key,'logsig_10')
        logsig_10_rrmse = [logsig_10_rrmse; rrmse];
    elseif strcmp(key,'logsig_10_10')
        logsig_10_10_rrmse = [logsig_10_10_rrmse; rrmse];
    elseif strcmp(key,'tansig_5')
        tansig_5_rrmse = [tansig_5_rrmse; rrmse];
    elseif strcmp(key,'tansig_5_5')
        tansig_5_5_rrmse = [tansig_5_5_rrmse; rrmse];
    elseif strcmp(key,'tansig_10')
        tansig_10_rrmse = [tansig_10_rrmse; rrmse];
    elseif strcmp(key,'tansig_10_10')
        tansig_10_10_rrmse = [tansig_10_10_rrmse; rrmse];
    end
end

[mean_poslin_5, var_poslin_5, std_poslin_5] = meanSTDandVar(poslin_5_rrmse);
[mean_poslin_5_5, var_poslin_5_5,std_poslin_5_5] = meanSTDandVar(poslin_5_5_rrmse);
[mean_poslin_10, var_poslin_10,std_poslin_10] = meanSTDandVar(poslin_10_rrmse);
[mean_poslin_10_10, var_poslin_10_10,std_poslin_10_10] = meanSTDandVar(poslin_10_10_rrmse);

[mean_tansig_5, var_tansig_5, std_tansig_5] = meanSTDandVar(tansig_5_rrmse);
[mean_tansig_5_5, var_tansig_5_5, std_tansig_5_5] = meanSTDandVar(tansig_5_5_rrmse);
[mean_tansig_10, var_tansig_10, std_tansig_10] = meanSTDandVar(tansig_10_rrmse);
[mean_tansig_10_10, var_tansig_10_10, std_tansig_10_10] = meanSTDandVar(tansig_10_10_rrmse);

[mean_logsig_5, var_logsig_5,std_logsig_5] = meanSTDandVar(logsig_5_rrmse);
[mean_logsig_5_5, var_logsig_5_5,std_logsig_5_5] = meanSTDandVar(logsig_5_5_rrmse);
[mean_logsig_10, var_logsig_10,std_logsig_10] = meanSTDandVar(logsig_10_rrmse);
[mean_logsig_10_10, var_logsig_10_10,std_logsig_10_10] = meanSTDandVar(logsig_10_10_rrmse);

poslin_5 = [mean_poslin_5, var_poslin_5, std_poslin_5];
poslin_5_5 = [mean_poslin_5_5, var_poslin_5_5,std_poslin_5_5];
poslin_10 = [mean_poslin_10, var_poslin_10,std_poslin_10];
poslin_10_10 = [mean_poslin_10_10, var_poslin_10_10,std_poslin_10_10];

tansig_5 = [mean_tansig_5, var_tansig_5, std_tansig_5];
tansig_5_5 = [mean_tansig_5_5, var_tansig_5_5,std_tansig_5_5];
tansig_10 = [mean_tansig_10, var_tansig_10,std_tansig_10];
tansig_10_10 = [mean_tansig_10_10, var_tansig_10_10,std_tansig_10_10];

logsig_5 = [mean_logsig_5, var_logsig_5, std_logsig_5];
logsig_5_5 = [mean_logsig_5_5, var_logsig_5_5,std_logsig_5_5];
logsig_10 = [mean_logsig_10, var_logsig_10,std_logsig_10];
logsig_10_10 = [mean_logsig_10_10, var_logsig_10_10,std_logsig_10_10];


poslin = zeros(3,3);
poslin(1,:) = poslin_5;
poslin(2,:) = poslin_5_5;
poslin(3,:) = poslin_10;
poslin(4,:) = poslin_10_10;
poslin(:,4) = [length(poslin_5_rrmse);length(poslin_5_5_rrmse);length(poslin_10_rrmse);length(poslin_10_10_rrmse)];

tansig = zeros(3,3);
tansig(1,:) = tansig_5;
tansig(2,:) = tansig_5_5;
tansig(3,:) = tansig_10;
tansig(4,:) = tansig_10_10;
tansig(:,4) = [length(tansig_5_rrmse);length(tansig_5_5_rrmse);length(tansig_10_rrmse);length(tansig_10_10_rrmse)];

logsig = zeros(3,3);
logsig(1,:) = logsig_5;
logsig(2,:) = logsig_5_5;
logsig(3,:) = logsig_10;
logsig(4,:) = logsig_10_10;
logsig(:,4) = [length(logsig_5_rrmse);length(logsig_5_5_rrmse);length(logsig_10_rrmse);length(logsig_10_10_rrmse)];
end

function [actfun,dimstr,key] = actFunAndStruct(file)
    actfun = string(file.net_mu.layers{end}.transferFcn);
    dim = file.net_mu.layers.dimensions; %cell array
    for i = 1:size(dim,1)-1
        if i == 1
            dimstr = '_'+string(dim(i));
        else
            dimstr = dimstr + '_'+string(dim(i));
        end
    end
    key = actfun+dimstr;
end


function [avg,variance,stddev] = meanSTDandVar(rmseArray)
    avg = mean(rmseArray);
    variance = var(rmseArray);
    stddev = std(rmseArray);
end

% end

% function dict = configOrAddToDict(dict,key,val)
%     if ~isConfigured(dict) %dict not configured => create key-value pair
%         dict(key) = val;
%     elseif ~isKey(dict,key)% is the dict is configured but this key does not exist, add value to key
%         dict(key) = val;
%     else
%         dict(key) = dict(key)+val;
%     end
% end
% 
% 
% function dict = AppendToDict(dict,key,val)
%     if ~isConfigured(dict) %dict not configured => create key-value pair
%         dict(key) = val;
%     elseif ~isKey(dict,key)% is the dict is configured but this key does not exist, add value to key
%         dict(key) = val;
%     else
%         dict(key) = {[dict(key);val]};
%     end
% end
% 

% 
% initializeExcel(fn)
% % writeToExcel(fn,actfunArray,structArray, rrmseArray);%,STD,Var)
% 
% 
% function writeToExcel(fn,actfun,structure, relRMSE)%,STD,Var)
%     % writematrix(initparams,fn, 'WriteMode','append')
%     writematrix([actfun structure relRMSE], fn, 'WriteMode','append')
%     writematrix([], fn, 'WriteMode','append')
% end
% 
% function initializeExcel(fn)
%     writematrix(["Activation function" "Hidden layer structure" "relRMSE"], fn, "WriteMode", "append")
%     writematrix([], fn, 'WriteMode','append')
% end
% 
% end