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

% how close can I get (within a multiplier factor) to the actual luminance
% of a reflectant using a  commercial camera?
function spectral_demo()
    close all;

    addpath('data/');
    addpath('methods/')
    % set wavelength range of interest (smallest overlap between datasets)
    WL = 390:5:745';
    
    % get standard observer CMFs
    st_obs      = get_CIE1931_CMF();    
    st_obs      = normalize_wavelengths(st_obs, WL);
    
    % get D65 standard illuminant (~sunlight)
    D65         = get_D65_spectrum();
    D65         = normalize_wavelengths(D65, WL)';
    
    % get the spectral power distributions of a standard color chart
    macbeth_spd = get_colorchart_spd();
    macbeth_spd = normalize_wavelengths(macbeth_spd, WL);
    
    % get the spectral camera responses of the spheron camera from SYNS
    cam_spd_res = get_spheron_response();
    cam_spd_res = normalize_wavelengths(cam_spd_res, WL);
    
    plot_spectral_distros(D65, WL, macbeth_spd, cam_spd_res, st_obs);

    %%%%%%%% Computing matrices for luminance conversion
    
    % get RGB to XYZ transform matrix
    % comment/uncomment below to test MIA vs MIP. You will see the latter is more accurate!
    % obs.: This is the T matrix we will use in the next demo
    T_MIA  = get_colorspace_xform_MIA(cam_spd_res, st_obs);
    T_MIP = get_colorspace_xform_MIP(cam_spd_res, st_obs);

    [tru_Y_MIA, cam_Y_MIA] = get_Y(macbeth_spd, st_obs, cam_spd_res, D65, T_MIA);
    [tru_Y_MIP, cam_Y_MIP] = get_Y(macbeth_spd, st_obs, cam_spd_res, D65, T_MIP);

    %% Plotting:
    figure; hold on; sz = 1:length(tru_Y_MIA);
    TY = scatter(sz, tru_Y_MIA, 95, 'o', 'filled');
    AY = scatter(sz, cam_Y_MIA, 155, 'x');
    PY = scatter(sz, cam_Y_MIP, 155, '+');
    
    TY.MarkerEdgeColor = [0.4940 0.1840 0.5560];
    TY.MarkerFaceColor = [0.4940 0.1840 0.5560];
    
    AY.MarkerEdgeColor = [0.0000, 0.4470, 0.7410];
    AY.MarkerFaceColor = [0.0000, 0.4470, 0.7410];
    AY.LineWidth = 1.5;
    
    PY.MarkerEdgeColor = [0.9290, 0.6940, 0.1250];
    PY.MarkerFaceColor = [0.9290, 0.6940, 0.1250];
    PY.LineWidth = 1.5;
    
    xlabel('Color tiles'); ylabel('Relative Y'); title('Luminance estimation methods');
    legend('true Y','MIM Y', 'MIMP Y','Location','NorthWest');
    ylim([0 1.05]); set(gca,'FontSize',15);

    percentage_error_MIA = 100.*abs(tru_Y_MIA - cam_Y_MIA)./tru_Y_MIA;
    percentage_error_MIP = 100.*abs(tru_Y_MIP - cam_Y_MIP)./tru_Y_MIP;

    figure;
    b = bar(1:length(percentage_error_MIA), [percentage_error_MIA; percentage_error_MIP]);
    yl_MIA = yline(mean(percentage_error_MIA),'--','Mean MIM');
    yl_MIA.Color = [0.0000, 0.4470, 0.7410]; yl_MIA.LineWidth = 2;
    yl_MIP = yline(mean(percentage_error_MIP),'--','Mean MIMP');
    yl_MIP.Color = [0.9290, 0.6940, 0.1250]; yl_MIP.LineWidth = 2;
    
    xlabel('Color tiles'); ylabel('% Y error'); title('Luminance estimation error');
    axis([0 26 0 100]);
    xticks([5 10 15 20 25]); xticklabels({'5','10', '15', '20'})
    yticks([0 20 40 60 80 100]);
    fsz = 15;
    set(gca,'FontSize',fsz);
    yl_MIA.FontSize = fsz;
    yl_MIP.FontSize = fsz;

end

function [tru_Y, cam_Y] = get_Y(macbeth_spd, st_obs, cam_spd_res, D65, T)
    % for each sample on the color chart, simulated with D65 illumination
    for i = 1:size(macbeth_spd,2)
        % we calculate the real (as seen by the standard observer) XYZ values
        tru_XYZ(:,i) =    trapz( D65 .* macbeth_spd(:,i) .* st_obs,      1);
        % and recovered XYZ (using RGB values from the Spheron camera's
        % spectral response curves) and the T matrix we just calculated above
        cam_XYZ(:,i) = T*(trapz( D65 .* macbeth_spd(:,i) .* cam_spd_res, 1))';
    end
    % normalized up to a multiplier
    tru_Y = tru_XYZ(2,:)./max(tru_XYZ(2,:));
    cam_Y = cam_XYZ(2,:)./max(cam_XYZ(2,:));
end

function plot_spectral_distros(D65, WL, macbeth_spd, cam_spd_res, st_obs)

    D65 = D65./max(D65(:));
    
    figure;
    
    subplot(1,3,1);
    plot(WL, macbeth_spd, 'LineWidth',1.5);
    hold on;
    plot(WL, D65,'-.k', 'LineWidth', 5);
    xlim([385 750]);
    ylim([0 1.05]);
    yticks([0 0.5 1.0]);
    xticks([400 450 500 550 600 650 700 750]);
    title('Spectral Power Distributions')
    set(gca, 'FontSize', 15);
%     legend({'D65'}); % not able to do it because there's so many lines
    
    subplot(1,3,2);
    plot(WL, st_obs, 'LineWidth',2.5);
    xlim([385 750]);
%     yticks([0 0.5 1.0]);
    xticks([400 450 500 550 600 650 700 750]);
    title('1931 XYZ CMFs');
    legend({'X CMF','Y CMF','Z CMF'});
    yticks([]);
    set(gca, 'FontSize', 15);
    
    
    subplot(1,3,3);
    plot(WL, cam_spd_res, 'LineWidth',2.5);
    xlim([385 750]);
%     yticks([0 0.5 1.0]);
    xticks([400 450 500 550 600 650 700 750]);
    title('Spheron HDR CSSFs');
    legend({'R CSSF','G CSSF','B CSSF'}, 'Location', 'NorthWest');
    yticks([]);
    set(gca, 'FontSize', 15);
    

end