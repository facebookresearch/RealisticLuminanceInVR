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

% This function uses the T matrix obtained using the "maximum ignorance
% method with positivity" from the previous demo.
% pass 3xN RGB values, get back 3xN XYZ values
function Y = spheron_RGB2Yunscaled(hdr)
    [hdrx, hdry, hdrz] = size(hdr); 
    hdr1D    = reshape(hdr, [hdrx * hdry, 3]);
    hdr1DXYZ = spheron_RGB2XYZ(hdr1D');
    
    hdrXYZ   = reshape(hdr1DXYZ', [hdrx, hdry, hdrz]);

    Y = hdrXYZ(:,:,2);
end


