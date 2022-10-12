%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2022 Meta Platforms, Inc. and affiliates
%
% This repository contains Matlab code associated with our paper:
% 
% Realistic Luminance in VR 
% Nathan Matsuda*, Alexandre Chapiro*, Yang Zhao, Clinton Smith, Romain Bachy, Douglas Lanman 
% Conference track of SIGGRAPH Asia 2022
%
% Contact:
% Alex Chapiro (alex@chapiro.net) 
% Nathan Matsuda (nathan.matsuda@fb.com)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% parses the experiment results and generates the plots in the paper
function experiment_parser()

    close all;
    % recover data from participants as saved in .csv file
    [RL] = data_parser('experiment_results/experiment_grayscale/');
    [RC] = data_parser('experiment_results/experiment_color/');
    
    % process data and generate plot
    data_processor(RL,RC);
    
    
end

% reads results from .csv file into table
function [R] = data_parser(directory)
    h = dir(directory);
    for i = 4:length(h)
        % loading participant responses in table format
        data{i} = readtable([directory h(i).name]);
        % user id #
        user(i-3) = data{i}{1,3};
        % study was done in 2 blocks in random order - starting from lowest
        % luminance or higherst luminance
        lowfirst(i-3) = strcmp(data{i}{1,8},'StartLow');
        % check which case happened for this participant and save
        % results accordingly
        R(i-3,:) = data{i}{:,9};
        if(lowfirst(i-3))
            divider = size(R,2)/2;
            R_temp = R(i-3,:);
            R(i-3,1:divider) = R_temp(divider+1:end);
            R(i-3,divider+1:end) = R_temp(1:divider);
        end
    end

end

function data_processor(RL, RC)


    % the study was conducted with pre-rendered discrete luminance log-offset steps
    meanVals = [6	7.0218	8.2177	9.6172	11.255	13.172	15.415	18.04	21.113	24.708	28.916	33.841	39.604	46.349	54.242	63.479	74.29	86.942	101.75	119.08	139.36	163.09	190.86	223.37	261.41	305.93	358.03	419.01	490.36	573.87	671.61	785.99	919.84	1076.5	1259.8	1474.4	1725.5	2019.3	2363.2	2765.7];
    % recovering the luminance values participants saw
    % obs.: experiment indexing from 0, so adding 1 here for Matlab convention
    luminances_L = meanVals(RL+1);
    
    % loading ground truth mean luminance values of stimuli
    load('data/experiment_mean_luminances.mat');
    ground_truth_luminances_L = [mean_luminance_indoor(1:end-1) mean_luminance_outdoor];
    
    % recovering luminances seen by participants in color trial, including calibration constant
    luminances_C = meanVals(RC+1)./(1.8318./(1/0.5714));
    
    % mean luminance over all participants
    mean_Luminance_L = mean(luminances_L,1);
    % standard error over all participants
    stderr_Luminance_L = std(luminances_L,[],1) ./ sqrt(size(luminances_L,1));
     
    % mean luminance over all participants
    mean_Luminance_C = mean(luminances_C,1);
    % standard error over all participants
    stderr_Luminance_C = std(luminances_C,[],1) ./ sqrt(size(luminances_C,1));
    
    cols = parula(4)';
    % generate plot
    figure('Name','VR-HDR results','NumberTitle','off'); hold on;
    % start low vs. start high
    divider = size(luminances_L,2)/2;

    range1 = 1:divider; range2 = divider+1:length(mean_Luminance_L);
    % sorting based on ground truth luminance
    % coincidentally all outdoor scenes have higher average luminance than
    % all indoor scenes, so we don't need to separate further
    [a, b] = sort(ground_truth_luminances_L);

    % start high data
    errorbar(1:divider, mean_Luminance_L(b),stderr_Luminance_L(b), ...
        'o','Color', cols(:,1), 'MarkerSize',10, 'MarkerEdgeColor',cols(:,1),'MarkerFaceColor',cols(:,1));
    % start low data
    errorbar(1:divider, mean_Luminance_L(b+19),stderr_Luminance_L(b+19), ...
        'o','Color', cols(:,2), 'MarkerSize',10, 'MarkerEdgeColor',cols(:,2),'MarkerFaceColor',cols(:,2));       
    % ground truth data
    plot(1:divider, ground_truth_luminances_L(b),'--ks',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor',cols(:,4))
    
    % if wanting to plot mean trend
%     mean_trend = (mean_Luminance_L(1:19) + mean_Luminance_L(20:end))./2;
%     plot(1:19, mean_trend(b),'--k');

    % vertical line to separate indoor/outdoor plots
    xline(9.5,'LineWidth',2)
    % log scale for y axis
    set(gca, 'YScale', 'log')
    % no special significance to 20k nits here, just a big enough value
    ylim([10 20000]);
    ylabel('Preferred Mean Luminance (nits)');
    grid on; xticks(1:19); xticklabels([]);
    % legends and informative text
    legend('start high L','start low L','ground truth','Location','NorthWest');
    text(3.2,7,'Indoor', 'FontSize', 15, 'FontName','times');
    text(13.5,7,'Outdoor', 'FontSize', 15, 'FontName','times');
    set(gca,'fontname','times','fontsize',15);

%     print('figure_results.pdf','-dpdf');

    % same plot for study pilot with color
    plotting_color_study = 1;
    if(plotting_color_study)
        figure('Name','VR-HDR results [COLOR]','NumberTitle','off'); hold on;
        % start high data
        errorbar(1:divider, mean_Luminance_C(b),stderr_Luminance_C(b), ...
            '--o','Color', cols(:,3), 'MarkerSize',10, 'MarkerEdgeColor',cols(:,3),'MarkerFaceColor',cols(:,3));
        % start low data
        errorbar(1:divider, mean_Luminance_C(b+19),stderr_Luminance_C(b+19), ...
            '--o','Color', cols(:,4), 'MarkerSize',10, 'MarkerEdgeColor',cols(:,4),'MarkerFaceColor',cols(:,4));
            % ground truth data
    
        plot(1:divider, ground_truth_luminances_L(b),'--ks',...
            'LineWidth',2,...
            'MarkerSize',10,...
            'MarkerEdgeColor','k',...
            'MarkerFaceColor',cols(:,4))
    
            % vertical line to separate indoor/outdoor plots
        xline(9.5,'LineWidth',2)
        % log scale for y axis
        set(gca, 'YScale', 'log')
        % no special significance to 20k nits here, just a big enough value
        ylim([10 20000]);
        ylabel('Preferred Mean Luminance (nits)');
        grid on; xticks(1:19); xticklabels([]);
        % legends and informative text
        legend('start high L','start low L','ground truth','Location','NorthWest');
        text(3.2,7,'Indoor', 'FontSize', 15, 'FontName','times');
        text(13.5,7,'Outdoor', 'FontSize', 15, 'FontName','times');
        set(gca,'fontname','times','fontsize',15);
    end

    % additional plots and statistical analysis of results
    stat_analysis(luminances_L, luminances_C, range1, range2, ground_truth_luminances_L, plotting_color_study);

end

% get p-values and calculate per-condition means
function stat_analysis(Luminances_L, Luminances_C, range1, range2, grond_truth_luminances, plotting_color_study)


    data_L = stat_data_wrangling(Luminances_L, range1, range2);
    data_C = stat_data_wrangling(Luminances_C, range1, range2);
 
    if(~plotting_color_study)
        % plotting the results using a bar plot with error bars
        yvals   = [data_L.start_low_mean data_L.start_high_mean data_L.indoor_mean data_L.outdoor_mean];
        errvals = [data_L.start_low_stderr data_L.start_high_stderr data_L.indoor_stderr data_L.outdoor_stderr];
        figure; hold on;
        bar(1:4, yvals);
        xline(2.5,'LineWidth',5);
        errorbar(1:4, yvals, errvals,'ko');
        xticks([1 2 3 4])
        xticklabels({'start low','start high','indoor', 'outdoor'})
        xlabel('experiment conditions');
        ylabel('preferred mean in nits');
    else
        % plotting the results using a bar plot with error bars
        yvals   = [data_L.start_low_mean data_L.start_high_mean data_L.indoor_mean data_L.outdoor_mean ... 
                   data_C.start_low_mean data_C.start_high_mean data_C.indoor_mean data_C.outdoor_mean];
        errvals = [data_L.start_low_stderr data_L.start_high_stderr data_L.indoor_stderr data_L.outdoor_stderr ...
                   data_C.start_low_stderr data_C.start_high_stderr data_C.indoor_stderr data_C.outdoor_stderr];

        figure; hold on;
        bar(1:8, yvals);
        
        xline(2.5,'LineWidth',5);
        xline(4.5,'LineWidth',5);
        xline(6.5,'LineWidth',5);
        
        errorbar(1:8, yvals, errvals,'ko');
        xticks([1 2 3 4 5 6 7 8])
        xticklabels({'start low','start high','indoor', 'outdoor','start low c','start high c','indoor c', 'outdoor c'})
        xlabel('experiment conditions');
        ylabel('preferred mean in nits');
    end
    
    % normal vs. color comparison
    figure; hold on;
    YL = mean(data_L.Y); YC = mean(data_C.Y);
    SL = std(data_L.Y) ./ sqrt(length(data_L.Y)); 
    SC = std(data_C.Y) ./ sqrt(length(data_C.Y)); 
    bar(1:2, [YL YC]);
    errorbar(1:2, [YL YC], [SL SC], 'ko');
    xticks([1 2])
    xticklabels({'luminance only','color'});
    ylabel('preferred mean in nits');

    
    % run ANOVAN, get p-values
    % condition order: participants | high/low | indoor/outdoor
    p = anovan(data_L.Y,{data_L.G1,data_L.G2,data_L.G3});

    compute_linear_correlation(Luminances_L, grond_truth_luminances);
    compute_linear_correlation(Luminances_C, grond_truth_luminances);
    
end

function compute_linear_correlation(Luminances, grond_truth_luminances)
    
    % linear correlation coefficient between responses and ground truth data
    indoor_cases = (Luminances(:,1:9)+Luminances(:,20:28)).*0.5;
    indoor_mean_responses = mean(indoor_cases,1);
    
    outdoor_cases = (Luminances(:,10:19)+Luminances(:,29:end)).*0.5;
    outdoor_mean_responses = mean(outdoor_cases,1);
    
    correlation_coef_indoor  = corr(indoor_mean_responses', grond_truth_luminances(1:9)')
    correlation_coef_outdoor = corr(outdoor_mean_responses', grond_truth_luminances(10:end)')

end

function data = stat_data_wrangling(Luminances, range1, range2)

    % participant
    g1 = ones(size(Luminances));
    for i = 1:size(g1,1)
        g1(i,:) = i;
    end
    data.G1 = make_vector(g1);
    
    % start high / start low
    g2 = ones(size(Luminances));
    g2(:,range2) = 2;
    data.G2 = make_vector(g2);
    
    % indoor / outdoor
    g3 = ones(size(Luminances));
    g3(:,1:9)   = 2;
    g3(:,20:29) = 2;
    data.G3 = make_vector(g3);
    
    % converting into a 1D vector to pass to ANOVAN
    Y = make_vector(Luminances);
    data.Y = Y;
    
    % computing means and standard errors for each condition manually
    data.start_high_mean   = mean(Y(data.G2==1));
    data.start_high_stderr = std(Y(data.G2==1)) ./ sqrt(length(Y(data.G2==1)));
    data.start_low_mean    =  mean(Y(data.G2==2));
    data.start_low_stderr  = std(Y(data.G2==2)) ./ sqrt(length(Y(data.G2==2)));
    
    data.indoor_mean     = mean(Y(data.G3==2));
    data.indoor_stderr   = std(Y(data.G3==2)) ./ sqrt(length(Y(data.G3==2)));
    data.outdoor_mean    = mean(Y(data.G3==1));
    data.outdoor_stderr  = std(Y(data.G3==1)) ./ sqrt(length(Y(data.G3==1)));

end

% make table into 1D vector to pass to ANOVAN function
function Y = make_vector(y)
    Y = reshape(y, 1, []);
end