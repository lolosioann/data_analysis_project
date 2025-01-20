%% Exercise 7, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% Φόρτωση δεδομένων
data = readtable('TMS.xlsx'); % Αντικαταστήστε με το αρχείο σας

% Φιλτράρισμα για TMS = 1
data = data(data.TMS == 1, :);
% Clean data
data.Stimuli = str2double(data.Stimuli);
data.Intensity = str2double(data.Intensity);
data.Spike = str2double(data.Spike);
data.Frequency = str2double(data.Frequency);
data.CoilCode = str2double(data.CoilCode);

% Αφαίρεση γραμμών με NaN
data = rmmissing(data);

% Δημιουργία πίνακα ανεξάρτητων μεταβλητών X και εξαρτημένης μεταβλητής y
X = [data.Setup, data.Stimuli, data.Intensity, ...
     data.Spike, data.Frequency, data.CoilCode];
y = data.EDduration;

% Διαχωρισμός δεδομένων σε σύνολο εκμάθησης (70%) και σύνολο ελέγχου (30%)
cv = cvpartition(size(X, 1), 'Holdout', 0.2); % 70% training, 30% testing
X_train = X(training(cv), :); % Σύνολο εκμάθησης
y_train = y(training(cv));
X_test = X(test(cv), :); % Σύνολο ελέγχου
y_test = y(test(cv));

% Fit το πλήρες μοντέλο στο σύνολο εκμάθησης
mdl_full = fitlm(X_train, y_train);

% Προβλέψεις στο σύνολο ελέγχου
y_pred_full = predict(mdl_full, X_test);

% Υπολογισμός MSE στο σύνολο ελέγχου
MSE_full = mean((y_test - y_pred_full) .^ 2);

% Εμφάνιση αποτελεσμάτων
fprintf('Πλήρες Μοντέλο: MSE στο σύνολο ελέγχου = %.4f\n', MSE_full);

% Fit το stepwise μοντέλο στο σύνολο εκμάθησης
mdl_stepwise = stepwiselm(X_train, y_train);

% Προβλέψεις στο σύνολο ελέγχου
y_pred_stepwise = predict(mdl_stepwise, X_test);

% Υπολογισμός MSE στο σύνολο ελέγχου
MSE_stepwise = mean((y_test - y_pred_stepwise) .^ 2);

% Εμφάνιση αποτελεσμάτων
fprintf('Μοντέλο Βηματικής Παλινδρόμησης: MSE στο σύνολο ελέγχου = %.4f\n', MSE_stepwise);
disp(mdl_stepwise.Formula);

% Fit LASSO στο σύνολο εκμάθησης με cross-validation
[B, FitInfo] = lasso(X_train, y_train, 'CV', 10); % 10-fold cross-validation

% Επιλογή των συντελεστών για το βέλτιστο λ
idxLambdaMinMSE = FitInfo.IndexMinMSE;
lassoCoeffs = B(:, idxLambdaMinMSE); % Συντελεστές για το βέλτιστο λ
lassoIntercept = FitInfo.Intercept(idxLambdaMinMSE);

% Προβλέψεις στο σύνολο ελέγχου
y_pred_lasso = X_test * lassoCoeffs + lassoIntercept;

% Υπολογισμός MSE στο σύνολο ελέγχου
MSE_lasso = mean((y_test - y_pred_lasso) .^ 2);

% Εμφάνιση αποτελεσμάτων
fprintf('LASSO: MSE στο σύνολο ελέγχου = %.4f\n', MSE_lasso);

% Βηματική παλινδρόμηση μόνο στο σύνολο εκμάθησης
mdl_stepwise_train = stepwiselm(X_train, y_train);

% LASSO μόνο στο σύνολο εκμάθησης
[B_train, FitInfo_train] = lasso(X_train, y_train, 'CV', 10);
idxLambdaMinMSE_train = FitInfo_train.IndexMinMSE;
lassoCoeffs_train = B_train(:, idxLambdaMinMSE_train);
lassoIntercept_train = FitInfo_train.Intercept(idxLambdaMinMSE_train);

% Προβλέψεις και MSE για κάθε μοντέλο στο σύνολο ελέγχου
y_pred_stepwise_train = predict(mdl_stepwise_train, X_test);
MSE_stepwise_train = mean((y_test - y_pred_stepwise_train) .^ 2);

y_pred_lasso_train = X_test * lassoCoeffs_train + lassoIntercept_train;
MSE_lasso_train = mean((y_test - y_pred_lasso_train) .^ 2);

% Εμφάνιση αποτελεσμάτων
fprintf('Βηματική Παλινδρόμηση (εκμάθηση): MSE = %.4f\n', MSE_stepwise_train);
fprintf('LASSO (εκμάθηση): MSE = %.4f\n', MSE_lasso_train);



