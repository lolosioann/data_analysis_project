%% Exercise 1, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
EDduration_with_TMS = data.EDduration(data.TMS == 1);
EDduration_without_TMS = data.EDduration(data.TMS == 0);
% fit the data to different distributions and perform the chi2gof test
dists = {'Normal', 'Exponential', 'Lognormal', 'Gamma', 'Rayleigh', 'Weibull'};
best_pval_with_TMS = 0;
best_pval_without_TMS = 0;
    for i = 1:length(dists)
        try
            % fit the distributions
            dist_with_TMS = fitdist(EDduration_with_TMS, dists{i});
            dist_without_TMS = fitdist(EDduration_without_TMS, dists{i});
            % do the chi2gof test
            [~, pval_with_TMS] = chi2gof(EDduration_with_TMS, 'CDF', dist_with_TMS);
            [~, pval_without_TMS] = chi2gof(EDduration_without_TMS, 'CDF', dist_without_TMS);
            % keep the best p-value
            if pval_with_TMS > best_pval_with_TMS
                best_pval_with_TMS = pval_with_TMS;
                best_dist_with_TMS = dist_with_TMS;
            end
            if pval_without_TMS > best_pval_without_TMS
                best_pval_without_TMS = pval_without_TMS;
                best_dist_without_TMS = dist_without_TMS;
            end
        catch
            continue
        end
    end
% print the results
fprintf("Best distribution with TMS: %s\n", best_dist_with_TMS.DistributionName);
fprintf('With p-val: %f\n', best_pval_with_TMS);
fprintf("\nBest distribution without TMS: %s\n", best_dist_without_TMS.DistributionName);
fprintf('With p-val: %f\n', best_pval_without_TMS);
% plot the histograms and the fitted distributions
figure();
subplot(1, 2, 1);
bins = floor(sqrt(length(EDduration_with_TMS)));
histfit(EDduration_with_TMS, bins, 'Exponential');
legend('Data', 'Fitted distribution');
title('ED duration with TMS');
subplot(1, 2, 2);
bins = floor(sqrt(length(EDduration_without_TMS)));
histfit(EDduration_without_TMS, bins, 'Exponential');
legend('Data', 'Fitted distribution');
title('ED duration without TMS');