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
disp(length(EDduration_oct));
disp(length(EDduration_circle));
% resample the data
resampled_EDduration_oct = random(dist_oct, NUMBER_OF_SAMPLES, 1);
resampled_EDduration_circle = random(dist_circle, NUMBER_OF_SAMPLES, 1);
% calc the chi2 values for the sampled data
resampled_chi2_oct =  chi2stat(resampled_EDduration_oct);
resampled_chi2_circle =  chi2stat(resampled_EDduration_circle);
% calc the p-values for the original data
[~, p_val_oct, stats_oct] = chi2gof(EDduration_oct, 'CDF', dist_oct);
[h, p_val_circle, stats_circle] = chi2gof(EDduration_circle, 'CDF', dist_circle);
chi2_oct = stats_oct.chi2stat;
chi2_circle = stats_circle.chi2stat;
% calculate the empirical pvalues
empirical_p_val_oct = sum(resampled_chi2_oct > chi2_oct) / NUMBER_OF_SAMPLES;
empirical_p_val_circle = sum(resampled_chi2_circle > chi2_circle) / NUMBER_OF_SAMPLES;
disp(['Parametric p-value of octocoil: ', num2str(p_val_oct)]);
disp(['Resampling p-value of octocoil: ', num2str(empirical_p_val_oct)]);
disp(['Parametric p-value of circle coil: ', num2str(p_val_circle)]);
disp(['Resampling p-value of circle coil: ', num2str(empirical_p_val_circle)]);
%% COMMENTS - RESULTS
% It is clear from the results that the Chi2_0 value does not fall on the right tail of the distribution for neither of the two cases (pval > 0.95 for both). We can see that the resampling method gave us p-values that are much larger than the parametric ones, suggesting that the number of samples is not enough to make a reliable estimation of the p-value using a parametric approach.