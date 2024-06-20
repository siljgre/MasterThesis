 % load('11_tansig_105.mat')
 % calcRelRMSE(t, y, t_exp1, t_exp2, y_exp1, y_exp2)

 function [meanRelRMSE,RMSE1rel,RMSE2rel,meanRelRMSEvec] = calcRelRMSE(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
    % Excluding CO2!
    y = y(:,2:end);
    y_exp1 = y_exp1(:,2:end);
    y_exp2 = y_exp2(:,2:end); 
    
    % Interpolate the ANN output t and y to match the times of each experiment
    y1= interp1(t, y, t_exp1, 'linear', 'extrap');
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');

    % Calculating RMSE for exp1 and exp2
    RMSE1 = rmse(y1,y_exp1); % [rmseV rmseX rmseS rmseCO2]
    RMSE2 = rmse(y2,y_exp2);

    RMSE1rel = RMSE1./sqrt((sum(y_exp1.^2))); %vector
    RMSE2rel = RMSE2./sqrt((sum(y_exp2.^2))); %vector

    % Mean rel. RMSE in each state
    meanRelRMSEvec = (RMSE1rel + RMSE2rel)/2; %vector

    % Mean rel. RMSE for all states in total
    meanRelRMSE = mean(meanRelRMSEvec); %scalar
    
end


