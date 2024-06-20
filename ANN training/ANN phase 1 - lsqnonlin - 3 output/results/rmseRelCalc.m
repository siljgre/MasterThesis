 % load('11_tansig_105.mat')
 % calcRelRMSE(t, y, t_exp1, t_exp2, y_exp1, y_exp2)

 function meanRelRMSE = calcRelRMSE(t, y, t_exp1, t_exp2, y_exp1, y_exp2)
    % Interpolate the ANN output t and y to match the times of each experiment
    y1= interp1(t, y, t_exp1, 'linear', 'extrap');
    y2= interp1(t, y, t_exp2, 'linear', 'extrap');

    % Calculating RMSE for exp1 and exp2
    RMSE1 = rmse(y1,y_exp1); % [rmseV rmseX rmseS rmseCO2]
    RMSE2 = rmse(y2,y_exp2);

    RMSE1rel = RMSE1/sqrt((sum(y_exp1.^2)));
    RMSE2rel = RMSE2./sqrt((sum(y_exp1.^2)));

    % Total RMSE (exp1+exp2), sum of all states
    meanRelRMSEvec = (RMSE1rel + RMSE2rel)/2; %vector
    meanRelRMSE = mean(meanRelRMSEvec); %scalar
end


