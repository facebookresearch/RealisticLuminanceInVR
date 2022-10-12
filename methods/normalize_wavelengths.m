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

% takes in an SPD with its associated wavelengths and interpolates it to
% the WL given in WL. Note: WL must be <= the space SPD is defined in
function SPD = normalize_wavelengths(SPD, WL)

    SPD = interp1(SPD(:,1), SPD(:,2:end), WL);
    
end
