%% Exercise 8, Group 3
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
clear;
clc;
close all;
% Φόρτωση δεδομένων
data = readtable('TMS.xlsx'); % Αντικαταστήστε με το αρχείο σας

% Φιλτράρισμα για TMS = 1
data = data(data.TMS == 1, :);
data.Stimuli = str2double(data.Stimuli);
data.Intensity = str2double(data.Intensity);
data.Spike = str2double(data.Spike);
data.Frequency = str2double(data.Frequency);
data.CoilCode = str2double(data.CoilCode);

% Αφαίρεση γραμμών με NaN
data = rmmissing(data);

% Αφαίρεση γραμμών με NaN

% Δημιουργία πίνακα ανεξάρτητων μεταβλητών X και εξαρτημένης μεταβλητής y
X = [data.Setup, data.Stimuli, data.Intensity, ...
     data.Spike, data.Frequency, data.CoilCode, ...
     data.preTMS];

% Προσθήκη postTMS αν χρειαστεί
X = [X, data.postTMS];

% Εξαρτημένη μεταβλητή
y = data.EDduration;

% Αν θέλετε να αγνοήσετε τη μεταβλητή Spike
% X_noSpike = X(:, [1, 2, 3, 5, 6, 7]); % Αφαίρεση της μεταβλητής Spike
% X_with_postTMS_noSpike = X_with_postTMS(:, [1, 2, 3, 5, 6, 7, 8]); % Χωρίς Spike

% Fit πλήρες μοντέλο
mdl_full = fitlm(X, y);

% Υπολογισμός MSE και Adjusted R^2
MSE_full = mean(mdl_full.Residuals.Raw .^ 2); % Μέσο Τετραγωνικό Σφάλμα
adjR2_full = mdl_full.Rsquared.Adjusted; % Προσαρμοσμένο R^2

% Εμφάνιση αποτελεσμάτων
fprintf('Πλήρες Μοντέλο: MSE = %.4f, Adjusted R^2 = %.4f\n', MSE_full, adjR2_full);

% Fit μοντέλο βηματικής παλινδρόμησης
mdl_stepwise = stepwiselm(X, y, "Verbose", 0);

% Υπολογισμός MSE και Adjusted R^2
MSE_stepwise = mean(mdl_stepwise.Residuals.Raw .^ 2); % Μέσο Τετραγωνικό Σφάλμα
adjR2_stepwise = mdl_stepwise.Rsquared.Adjusted; % Προσαρμοσμένο R^2

% Εμφάνιση αποτελεσμάτων
fprintf('Βηματική Παλινδρόμηση: MSE = %.4f, Adjusted R^2 = %.4f\n', MSE_stepwise, adjR2_stepwise);

% Fit LASSO με cross-validation
[B, FitInfo] = lasso(X, y, 'CV', 10); % 10-fold cross-validation

% Επιλογή των συντελεστών για το βέλτιστο λ
idxLambdaMinMSE = FitInfo.IndexMinMSE;
lassoCoeffs = B(:, idxLambdaMinMSE); % Συντελεστές για το βέλτιστο λ
lassoIntercept = FitInfo.Intercept(idxLambdaMinMSE);

% Προβλέψεις
y_pred_lasso = X * lassoCoeffs + lassoIntercept;

% Υπολογισμός MSE
MSE_lasso = mean((y - y_pred_lasso) .^ 2);

% Υπολογισμός Adjusted R^2
SST = sum((y - mean(y)).^2); % Ολική διακύμανση
SSR_lasso = sum((y - y_pred_lasso).^2); % Άθροισμα τετραγώνων σφάλματος
n = length(y); % Πλήθος παρατηρήσεων
p_lasso = sum(lassoCoeffs ~= 0); % Αριθμός επιλεγμένων μεταβλητών
adjR2_lasso = 1 - ((SSR_lasso / (n - p_lasso - 1)) / (SST / (n - 1)));

% Εμφάνιση αποτελεσμάτων
fprintf('LASSO: MSE = %.4f, Adjusted R^2 = %.4f\n', MSE_lasso, adjR2_lasso);


% PCA στα δεδομένα
[coeff, score, ~, ~, explained] = pca(X);

% Επιλογή αριθμού συνιστωσών (π.χ., 95% εξήγηση)
explained_variance = cumsum(explained);
numComponents = find(explained_variance >= 95, 1); % Πλήθος συνιστωσών

% Χρήση των πρώτων numComponents συνιστωσών
X_pca = score(:, 1:numComponents);

% Fit παλινδρόμηση με τις συνιστώσες
mdl_pcr = fitlm(X_pca, y);

% Υπολογισμός MSE και Adjusted R^2
MSE_pcr = mean(mdl_pcr.Residuals.Raw .^ 2);
adjR2_pcr = mdl_pcr.Rsquared.Adjusted;

% Εμφάνιση αποτελεσμάτων
fprintf('PCR: MSE = %.4f, Adjusted R^2 = %.4f\n', MSE_pcr, adjR2_pcr);


