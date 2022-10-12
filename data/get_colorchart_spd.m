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

function macbeth_spd = get_colorchart_spd()
    if(~isfile('MacbethColorChecker.xls'))
        disp('Download https://www.rit-mcsl.org/UsefulData/MacbethColorChecker.xls to data directory first');
        return
    end

    macbeth_spd = xlsread('MacbethColorChecker.xls');
    macbeth_spd = macbeth_spd(2:end,:);        
end