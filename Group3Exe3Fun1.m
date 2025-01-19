%% Exercise 3, Group 3, Function 1
% By: Niforos Athanasios,AEM: XXXXX
% By: Lolos Ioannis,AEM: 10674
function H = Group3Exe3Fun1(data, mu0)
    NUMBER_OF_SAMPLES = 1000;
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
        h = chi2gof(setup_data);
        if h == 0
            disp(['Setup ', num2str(i), ' is normally distributed']);
        else
            disp(['Setup ', num2str(i), ' is not normally distributed']);
        end
    end

    for i = [1 3 5 6]
        setup_data = data.EDduration(data.Setup == i);
        [h, ~] = ttest(setup_data, mu0);
        H(i) = h;
        if h == 0
            disp(['Setup ', num2str(i), ' has the same mean as the population']);
        else
            disp(['Setup ', num2str(i), ' has a different mean than the population']);
        end
    end

    for i = [2 4]
        bootmu = bootstrp(NUMBER_OF_SAMPLES, @mean, data.EDduration(data.Setup == i));
        [h, ~] = ttest(bootmu, mu0);
        H(i) = h;
        if h == 0
            disp(['Setup ', num2str(i), ' has the same mean as the population']);
        else
            disp(['Setup ', num2str(i), ' has a different mean than the population']);
        end
    end
end
