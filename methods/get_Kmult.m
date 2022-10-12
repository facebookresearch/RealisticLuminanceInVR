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

% get multiplier from code values to luminance for a known case
function kMult = get_Kmult()
    % getting approximate k multiplier value
    EV1 = get_EV(4, 1/15);
    M1 = 31.1287; % based on results in the code above
    kMult1 = M1/(2^EV1);
    
    % getting approximate k multiplier value
    EV2 = get_EV(5.6, 1/15);
    M2 = 64.0374; % based on results in the code above
    kMult2 = M2/(2^EV2);
    
    % getting approximate k multiplier value
    EV3 = get_EV(8, 1/15);
    M3 = 127.1510; % based on results in the code above
    kMult3 = M3/(2^EV3);
    
    kMult = mean([kMult1 kMult2 kMult3]);

end