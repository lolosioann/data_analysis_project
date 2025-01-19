%% Exercise 4, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% read the table and keep only the columns we need
data = readtable('TMS.xlsx');

setup_vals = 1:6;
ttest_results = NaN*ones(1, 6);
randomization_results = NaN*ones(1, 6);

alpha = 0.05;
for i = 1:6
    data_i = data(data.Setup == i & data.TMS == 1, :);
    X = data_i.preTMS;
    Y = data_i.postTMS;
    n = length(X);
    r = corr(X, Y);
    fprintf('Correlation coefficient for setup %s: %s (No. of Samples %s)\n',num2str(i), num2str(r), num2str(n));
    t0 = abs(r.*sqrt((n-2)./(1-r.^2)));
    if t0 < -tinv(1-alpha/2,n-2) || t0 > tinv(1-alpha/2,n-2)
        H = 1;
    else
        H = 0;
    end
    ttest_results(i) = H;

    L = 1000;
    t = NaN*ones(L,1);
    for j=1:L
        X2 = randsample(X,n,false);
        rr = corr(X2,Y);
        t(j) = rr*sqrt((n-2)*(1-rr^2));
    end
    t = sort(t);
    [~,pos] = min(abs(t-t0));
    if pos<L*alpha/2 || pos>L*(1-alpha/2)
        H = 1;
    else
        H = 0;
    end
    randomization_results(i) = H;
end

results = table(setup_vals', ttest_results', randomization_results', 'VariableNames', {'Setup', 'TTest', 'Randomization'});
disp("1 means that the null hypothesis is not rejected, 0 means that the null hypothesis is rejected");
disp(results)