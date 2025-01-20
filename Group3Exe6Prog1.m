%% Exercise 6, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
warning('off', 'all');

% Load data and filter for TMS = 1
data = readtable('TMS.xlsx');
data = data(data.TMS == 1, :);
% Clean data
data.Stimuli = str2double(data.Stimuli);
data.Intensity = str2double(data.Intensity);
data.Spike = str2double(data.Spike);
data.Frequency = str2double(data.Frequency);
data.CoilCode = str2double(data.CoilCode);
% data = rmmissing(data); % Remove rows with missing values

X = [data.Setup, data.Stimuli, data.Intensity, ...
    data.Frequency, data.CoilCode, data.Spike];
y = data.EDduration;

% Fit a linear model
fprintf('Linear model\n');
mdl = fitlm(X, y);
disp(['MSE for linear model: ', num2str(mdl.MSE)]);
disp(['Adjusted R^2 for linear model: ', num2str(mdl.Rsquared.Adjusted)]);
disp(mdl.Formula);
% disp(mdl.Coefficients);

% Stepwise regression
fprintf('\nStepwise regression\n');
mdl_stepwise = stepwiselm(X, y, 'linear', 'Verbose', 0);
disp(['MSE for stepwise linear model: ', num2str(mdl_stepwise.MSE)]);
disp(['Adjusted R^2 for stepwise linear model: ', num2str(mdl_stepwise.Rsquared.Adjusted)]);
disp(mdl_stepwise.Formula);

%  Lasso regression
fprintf('\nLasso regression\n');
[bLASSOv, FitInfo] = lasso(X,y,'CV',10);
idxLambdaMinMSE = FitInfo.IndexMinMSE;
lassoPlot(bLASSOv,FitInfo,'PlotType','CV');
legend('show')
bLassoIntercept = FitInfo.Intercept(idxLambdaMinMSE);
bLASSO = bLASSOv(:,idxLambdaMinMSE);
fprintf('LASSO: b=[')
fprintf(' %.2f %.2f',bLassoIntercept,bLASSO)
fprintf(']\n')
yfitLASSO = bLassoIntercept + X*bLASSO;
yfitLASSO; bLassoIntercept; bLASSO;
disp(['MSE for Lasso model: ', num2str(FitInfo.MSE(idxLambdaMinMSE))]);

% disp(['Adjusted R^2 for Lasso model: ', num2str(FitInfo.Rsquared.Adjusted(idxLambdaMinMSE))]);

% Remove Spike
X = [data.Setup, data.Stimuli, data.Intensity, ...
    data.Frequency, data.CoilCode];

% Fit a linear model
fprintf('\nLinear model without Spike\n');
mdl = fitlm(X, y);
disp(['MSE for linear model without Spike: ', num2str(mdl.MSE)]);
disp(['Adjusted R^2 for linear model without Spike: ', num2str(mdl.Rsquared.Adjusted)]);
disp(mdl.Formula);

% Stepwise regression
fprintf('\nStepwise regression without Spike\n');
mdl_stepwise = stepwiselm(X, y, 'linear', 'Verbose', 0);
disp(['MSE for stepwise linear model without Spike: ', num2str(mdl_stepwise.MSE)]);
disp(['Adjusted R^2 for stepwise linear model without Spike: ', num2str(mdl_stepwise.Rsquared.Adjusted)]);
disp(mdl_stepwise.Formula);

%  Lasso regression
fprintf('\nLasso regression without Spike\n');
[bLASSOv, FitInfo] = lasso(X,y,'CV',10);
idxLambdaMinMSE = FitInfo.IndexMinMSE;
lassoPlot(bLASSOv,FitInfo,'PlotType','CV');
legend('show')
bLassoIntercept = FitInfo.Intercept(idxLambdaMinMSE);
bLASSO = bLASSOv(:,idxLambdaMinMSE);
fprintf('LASSO: b=[')
fprintf(' %.2f %.2f',bLassoIntercept,bLASSO)
fprintf(']\n')
yfitLASSO = bLassoIntercept + X*bLASSO;
yfitLASSO; bLassoIntercept; bLASSO;
disp(['MSE for Lasso model without Spike: ', num2str(FitInfo.MSE(idxLambdaMinMSE))]);
% disp(['Adjusted R^2 for Lasso model without Spike: ', num2str(FitInfo.Rsquared.Adjusted(idxLambdaMinMSE))]);
