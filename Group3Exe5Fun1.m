%% Exercise 5, Group 3, Function 1
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674

function Group3Exe5Fun1(data)
    X = data.Setup;
    Y = data.EDduration;
    r = corr(X, Y);
    disp(['Correlation coefficient: ', num2str(r)]);
    %  Fit a linear model
    mdl_withTMS = fitlm(data, 'EDduration ~ Setup'); 
    R2_withTMS = mdl_withTMS.Rsquared.Ordinary; 
    adjR2_withTMS = mdl_withTMS.Rsquared.Adjusted; 
    disp(['R^2 for linear model: ', num2str(R2_withTMS)]);
    disp(['Adjusted R^2 for linear model: ', num2str(adjR2_withTMS)]);
    figure()
    plot(mdl_withTMS);

    % Fit a 5th degree polynomial
    x = data.Setup; y = data.EDduration;
    n = length(x);
    figure()
    scatter(x,y, 'x');
    k = 5; %poly degree
    b = polyfit(x,y,5);
    yfit = polyval(b,x);
    e = y - yfit;
    SSresid = sum(e.^2);
    SStotal = (n-1)*var(y);
    Rsq = 1 - SSresid/SStotal;
    adjRsq = 1 - SSresid/SStotal * (n-1)/(n-k-1);
    disp(['R^2 for 5th degree polynomial: ', num2str(Rsq)]);
    disp(['Adjusted R^2 for 5th degree polynomial: ', num2str(adjRsq)]);
    hold on
    plot(x,yfit,'color','r');
    legend('Data','Fit');
    title('5th degree polynomial fit');

    % Hypothesis test
    n = length(X);
    alpha = 0.05;
    t0 = abs(r.*sqrt((n-2)./(1-r.^2)));
    if t0 < -tinv(1-alpha/2,n-2) || t0 > tinv(1-alpha/2,n-2)
        H = 1;
        else
        H = 0;
    end
    disp(['Hypothesis test result: ', num2str(H)]);