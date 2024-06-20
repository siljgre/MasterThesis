function file = minCostFile(folder)
    cd(folder)
    clear
    matFiles = dir('*.mat');
    mincost = 1000;
    
    for k = 1:length(matFiles)
        file = matFiles(k).name;
        f = load(file);
        cost = computeCostlsq(f.y_exp1, f.y_exp2, f.t_exp1, f.t_exp2,f.t,f.y);
        if cost < mincost
            mincost = cost;
            mincostfile = file;
        end
    end
    
    file = mincostfile;
    
    function cost = computeCostlsq(y_exp1, y_exp2,t_exp1,t_exp2,t,y)
        % Interpolate the ANN output t and y to match the times of each experiment and the ode, for the norm calculation
        y1= interp1(t, y, t_exp1, 'linear', 'extrap');
        y2= interp1(t, y, t_exp2, 'linear', 'extrap');
        % y3= interp1(t, y, t_ode, 'linear', 'extrap');
        
        cost1 = norm(y1 - y_exp1);
        cost2 = norm(y2 - y_exp2);
        % cost3 = norm(y3 - y_ode); %not used in training
        cost = cost1+cost2;
    end
end
