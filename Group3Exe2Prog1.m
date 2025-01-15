%% Exercise 2, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;

NUMBER_OF_SAMPLES = 1000;

% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
EDduration_oct = data.EDduration(data.TMS == 1 & data.CoilCode == "1");
EDduration_circle = data.EDduration(data.TMS == 1 & data.CoilCode == "0");

% fit exponential distribution to the data
dist_oct = fitdist(EDduration_oct, 'Exponential');
dist_circle = fitdist(EDduration_circle, 'Exponential');

% resample the data
resampled_EDduration_oct = random(dist_oct, NUMBER_OF_SAMPLES, 1);
resampled_EDduration_circle = random(dist_circle, NUMBER_OF_SAMPLES, 1);
% calc the chi2 values for the sampled data
resampled_chi2_oct =  chi2stat(resampled_EDduration_oct);
resampled_chi2_circle =  chi2stat(resampled_EDduration_circle);
disp(['Chi2 of octocoil: ', num2str(mean(resampled_chi2_oct))]);
disp(['Chi2 of circle coil: ', num2str(mean(resampled_chi2_circle))]);
% calc the p-values for the original data
[~, p_val_oct, stats_oct] = chi2gof(EDduration_oct);
[~, p_val_circle, stats_circle] = chi2gof(EDduration_circle);
chi2_oct = stats_oct.chi2stat;
chi2_circle = stats_circle.chi2stat;

% TODO: Find the p-value of the chi2 values
% and compare it with the p-values of the original data
