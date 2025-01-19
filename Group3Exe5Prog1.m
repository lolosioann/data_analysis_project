%% Exercise 5, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
data = data(data.TMS == 1, :);
X = data.Setup;
Y = data.EDduration;
n = length(X);
alpha = 0.05;
r = corr(X, Y);
disp(['Correlation coefficient: ', num2str(r)]);
t0 = abs(r.*sqrt((n-2)./(1-r.^2)));
if t0 < -tinv(1-alpha/2,n-2) || t0 > tinv(1-alpha/2,n-2)
    H = 1;
    else
    H = 0;
end
disp(['Hypothesis test result: ', num2str(H)]);

plot(Y, X, 'o');