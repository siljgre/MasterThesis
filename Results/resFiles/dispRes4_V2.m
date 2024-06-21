% Display activation functions, comp. time and meanRMSE
matFiles = dir('*.mat');
for k = 1:length(matFiles)
    file = matFiles(k).name;
    phases = [];
    if ~contains(file,'RMSE')
        f = load(file);
        file

        %total runs meanRRMSE stdRRMSE meanTime stdTime 
        poslin1 = [f.poslin1(:,4) f.poslin1(:,1) f.poslin1(:,3) f.poslin1time(:,1)];
        tansig1 = [f.tansig1(:,4) f.tansig1(:,1) f.tansig1(:,3) f.tansig1time(:,1)];
        logsig1 = [f.logsig1(:,4) f.logsig1(:,1) f.logsig1(:,3) f.logsig1time(:,1)];
        
        poslin2 = [f.poslin2(:,4) f.poslin2(:,1) f.poslin2(:,3) f.poslin2time(:,1)];
        tansig2 = [f.tansig2(:,4) f.tansig2(:,1) f.tansig2(:,3) f.tansig2time(:,1)];
        logsig2 = [f.logsig2(:,4) f.logsig2(:,1) f.logsig2(:,3) f.logsig2time(:,1)];
        
        phase1 = [poslin1;tansig1;logsig1];
        phase2 = [poslin2;tansig2;logsig2];

        resTable = table(phase1,phase2)

        phases = [phase1 phase2];

        % Open a file for writing
    wfile = fopen('formatted_data'+string(file)+'.txt', 'w');

    % Loop through each row of the array
for i = 1:size(phases,1)
    % Create a formatted string for each row
    formattedRow = sprintf('%.0f & %.2g $\\pm$ %.1g & %.0f & %.0f & %.2g $\\pm$  %.1g & %.0f \\\\', phases(i, :));
    % Print the formatted row to the file

    if i==1
        actfun = '\multirow{4}{*}{ReLU}&';
    elseif i==5
        actfun = '\multirow{4}{*}{tansig}&';
    elseif i==9
        actfun = '\multirow{4}{*}{logsig}&';
    else 
        actfun = '&';
    end

    if i==1||i==5||i==9
        dim = '5 &';
    elseif i==2||i==6||i==10
        dim = '[5 5] &';
    elseif i==3||i==7||i==11
        dim = '10 &';
    elseif i==4||i==8||i==12
        dim = '[10 10] &';
    end
    formattedRow = [actfun dim formattedRow];
    fprintf(wfile, '%s\n', formattedRow);
end

% Close the file
fclose(wfile);

        phase1
        % bar plots
        % figure  
        % title(file,'Interpreter','none')
        % set(gca,'XtickLabel',['poslin';'tansig';'logsig']);
        % barplot2(file)
        % saveas(gcf, 'bar'+string(file)+'.png');
        % close
    % elseif strcmp(file,'RMSE.mat')
    %     f=load(file);
    %     struct2table(f)
    end
end


