%% Exercise 3, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
data = data(data.TMS == 0, :);
% calc the mean ED duration
mu0 = mean(data.EDduration);

lengths = zeros(1, 6);
for i = 1:6
    setup_data = data.EDduration(data.Setup == i);
    lengths(i) = length(setup_data);
end

disp('Number of samples for each setup:');
disp(lengths);

figure();
for i = 1:6
    setup_data = data.EDduration(data.Setup == i);
    subplot(2, 3, i);
    histfit(setup_data);
    title(['Setup ', num2str(i)]);
end

figure();
for i = 1:6
    setup_data = data.EDduration(data.Setup == i);
    subplot(2, 3, i);
    boxplot(setup_data);
    title(['Setup ', num2str(i)]);
    % mu = mean(setup_data);
    % sigma = std(setup_data);
    % disp(['Setup ', num2str(i), ' mean: ', num2str(mu), ' std: ', num2str(sigma)]);
end

% for i = [2 4]
%     setup_data = data.EDduration(data.Setup == i);
%     histfit(setup_data);
%     dist = fitdist(setup_data, 'Normal');
%     if chi2gof(setup_data, 'CDF', dist)
%         disp(['Setup ', num2str(i), ' is not normally distributed']);
%     else
%         disp(['Setup ', num2str(i), ' is normally distributed']);
%     end
%     mu = mean(setup_data);
%     sigma = std(setup_data);
%     disp(['Setup ', num2str(i), ' mean: ', num2str(mu), ' std: ', num2str(sigma)]);
% end