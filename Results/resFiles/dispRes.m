% Display activation functions, comp. time and meanRMSE
matFiles = dir('*.mat');
for k = 1:length(matFiles)
    file = matFiles(k).name;
    if ~contains(file,'RMSE')
        f = load(file);
        file

        %meanRRMSE stdRRMSE %meanTime %stdTime %total runs
        poslin1 = [f.poslin1(:,1) f.poslin1(:,3) f.poslin1time(:,1) f.poslin1time(:,3) f.poslin1(:,4)];
        tansig1 = [f.tansig1(:,1) f.tansig1(:,3) f.tansig1time(:,1) f.tansig1time(:,3) f.tansig1(:,4)];
        logsig1 = [f.logsig1(:,1) f.logsig1(:,3) f.logsig1time(:,1) f.logsig1time(:,3) f.logsig1(:,4)];
        
        poslin2 = [f.poslin2(:,1) f.poslin2(:,3) f.poslin2time(:,1) f.poslin2time(:,3) f.poslin2(:,4)];
        tansig2 = [f.tansig2(:,1) f.tansig2(:,3) f.tansig2time(:,1) f.tansig2time(:,3) f.tansig2(:,4)];
        logsig2 = [f.logsig2(:,1) f.logsig2(:,3) f.logsig2time(:,1) f.logsig2time(:,3) f.logsig2(:,4)];
        
        phase1 = [poslin1;tansig1;logsig1];
        phase2 = [poslin2;tansig2;logsig2];

        resTable1 = table(phase1)
        resTable2 = table(phase2)
    end
end


