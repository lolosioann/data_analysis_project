%% Exercise 3, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
warning('off', 'all');

% read the table and keep only the columns we need
data = readtable('TMS.xlsx');
data_noTMS = data(data.TMS == 0, :);
data_TMS = data(data.TMS == 1, :);
% calc the mean ED duration
mu0 = mean(data.EDduration);
disp('Analysis for data with no TMS:');
H_noTMS = Group3Exe3Fun1(data_noTMS, mu0);
disp('Analysis for data with TMS:');
H_TMS = Group3Exe3Fun1(data_TMS, mu0);

setups = 1:6;
tbl = table(setups', H_noTMS', H_TMS', 'VariableNames', {'Setup', 'H_noTMS', 'H_TMS'});
disp(tbl);
%% COMMENTS - RESULTS
