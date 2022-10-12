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

function visualize_histogram(V, xlab, tit)

    Acc = V{1}(~isinf(V{1}));
    for i = 2:length(V)
        Acc = [Acc; V{i}(~isinf(V{i}))];
    end

    [~,edges] = histcounts(log10(Acc));
    h = figure;

    histogram(Acc,10.^edges);
    set(gca,'xscale','log');
        
    xlabel(xlab)
    ylabel('Count')
    title(tit);

    [~,L1,U1,~] = isoutlier(Acc,'percentiles',[5 95]);
    [~,L2,U2,~] = isoutlier(Acc,'percentiles',[1 99]);
    [~,L3,U3,~] = isoutlier(Acc,'percentiles',[0.1 99.9]);
    
    fprintf('%s:\n Upper: 5%% = %f | 1%% = %f | 0.1%% = %f \n  Lower: 5%% = %f | 1%% = %f | 0.1%% = %f \n', ...
        tit, U1, U2, U3, L1, L2, L3);
end



