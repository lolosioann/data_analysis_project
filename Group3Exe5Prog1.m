%% Exercise 5, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
dataTMS = data(data.TMS == 1, :);
dataNoTMS = data(data.TMS == 0, :);
disp('--------------------TMS data:--------------------');
Group3Exe5Fun1(dataTMS);
disp(' -------------------No TMS data:------------------');
Group3Exe5Fun1(dataNoTMS);
%% COMMENTS - RESULTS
%  We can see from the results that the correlation coefficient is higher
% for the TMS data than for the No-TMS data. This means that the TMS data
% are more correlated than the No-TMS data. The R^2 and adjusted R^2 are
% also higher for the TMS data, which means that the linear model fits the
% TMS data better than the No-TMS data. The 5th degree polynomial fit is
% also better for the TMS data, as the R^2 and adjusted R^2 are higher. The
% hypothesis test result is 1 for the TMS data, which means that the
% correlation coefficient is statistically significant. For the No-TMS
% data, the hypothesis test result is 0, which means that the correlation
% coefficient is not statistically significant. This means that the TMS
% data are more correlated than the No-TMS data, and the linear model and
% 5th degree polynomial fit are better for the TMS data. The fifth degree
%  polynomial was chosen because there were six distinct Setup values, so
%  the polynomial could be of degree 5. The scatter plot shows that the
%  data points are not linearly distributed, so a polynomial fit is more
%  appropriate in both cases.