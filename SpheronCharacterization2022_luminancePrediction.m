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

%Spheron camera characterization

close all;
addpath('methods/');

%% build tables manually based on lab measurements

% Spheron data values 02-2022 images
% to load these values, we need to use the SpheronDataLoad2022.m script

% from image 006 and XYData006.mat
Test040Exp15 = table({'HighRes'}, 4.0, 20.497969,0.56979841,0.79469728,1.5889676,2.1422958,2.5253215,3.8210049,5.8130617,6.9465904,9.3072414,12.233492,14.556299,17.486860,220.15009,0.11781782,0.32129151,0.61197382,1.2226918,1.9387316,2.7266955, ...
             'VariableNames',{'Resolution', 'Aperture', 'WhiteRef', 'MBE6', 'MBJ5', 'MBF6', 'MBI5', 'MBG6', 'MBH5', 'MBH6', 'MBG5', 'MBI6', 'MBF5', 'MBJ6', 'MBE5',  'GreyPlasma', 'MacBeth1', 'MacBeth2', 'MacBeth3', 'MacBeth4', 'MacBeth5', 'MacBeth6'});
% from image 007 and XYData007.mat
Test056Exp15 = table({'HighRes'}, 5.6, 10.105903,0.30736351,0.40098822,0.76996392,1.0802315,1.2407055,2.1093407,3.0588899,3.8569708,4.6469078,5.0468454,7.0423255,8.3877563,107.02811,0.069577940,0.17793590,0.32043216,0.61903858,0.97055680,1.3680568, ...
             'VariableNames',{'Resolution', 'Aperture', 'WhiteRef', 'MBE6', 'MBJ5', 'MBF6', 'MBI5', 'MBG6', 'MBH5', 'MBH6', 'MBG5', 'MBI6', 'MBF5', 'MBJ6', 'MBE5',  'GreyPlasma', 'MacBeth1', 'MacBeth2', 'MacBeth3', 'MacBeth4', 'MacBeth5', 'MacBeth6'});
% from image 008 and XYData008.mat
Test080Exp15 = table({'HighRes'}, 8.0, 5.0166512,0.16658814,0.21970546,0.38816565,0.52666199,0.60633314,0.97349930,1.5297041,1.7132518,2.1553209,2.8602593,3.9733696,4.8404312,53.829220,0.045250013,0.097110942,0.16979554,0.31045189,0.48273036,0.66979611, ...
             'VariableNames',{'Resolution', 'Aperture', 'WhiteRef', 'MBE6', 'MBJ5', 'MBF6', 'MBI5', 'MBG6', 'MBH5', 'MBH6', 'MBG5', 'MBI6', 'MBF5', 'MBJ6', 'MBE5',  'GreyPlasma', 'MacBeth1', 'MacBeth2', 'MacBeth3', 'MacBeth4', 'MacBeth5', 'MacBeth6'});
% from image 009 and XYData009.mat
Test056Exp08 = table({'HighRes'}, 5.6, 18.097038,0.54335487,0.74368125,1.4244273,1.8993618,2.2934704,3.6797206,5.2844086,6.4508071,8.7615337,10.047716,14.309416,15.505156,191.25819,0.11521259,0.30094081,0.57115841,1.1273794,1.7811307,2.5180833, ...
             'VariableNames',{'Resolution', 'Aperture', 'WhiteRef', 'MBE6', 'MBJ5', 'MBF6', 'MBI5', 'MBG6', 'MBH5', 'MBH6', 'MBG5', 'MBI6', 'MBF5', 'MBJ6', 'MBE5',  'GreyPlasma', 'MacBeth1', 'MacBeth2', 'MacBeth3', 'MacBeth4', 'MacBeth5', 'MacBeth6'});         
% from image 010 and XYData010.mat
Test056Exp30 = table({'HighRes'}, 5.6, 4.8820133,0.15620396,0.20333493,0.37059003,0.49584398,0.59641683,1.0129454,1.4055934,1.6702745,2.3765132,2.6335504,3.4550869,3.9095466,52.550205,0.044098463,0.097219013,0.17215458,0.31174964,0.48469648,0.67031723, ...
             'VariableNames',{'Resolution', 'Aperture', 'WhiteRef', 'MBE6', 'MBJ5', 'MBF6', 'MBI5', 'MBG6', 'MBH5', 'MBH6', 'MBG5', 'MBI6', 'MBF5', 'MBJ6', 'MBE5',  'GreyPlasma', 'MacBeth1', 'MacBeth2', 'MacBeth3', 'MacBeth4', 'MacBeth5', 'MacBeth6'});         
 
T = [Test040Exp15; Test056Exp15; Test080Exp15;  Test056Exp08; Test056Exp30];

% Luminance values (measured with Konica Minolta CS 160)
RefSurfaceGMClassic = [76.5 54.7 35.5 18.5 9.3 3.3];
[RefSurfaceGMClassic, ~] = sort(RefSurfaceGMClassic);

RefSurfaceGMExt =[569 369 233.5 132.1 65.8 18.5 15.2 45.3 78.1 193.8 307.4 488.8];
[RefSurfaceGMExt, ~] = sort(RefSurfaceGMExt);

RefSurfaceWhiteRef = 607;

RefSurfaceGrey = 6850;

RefSurfaceHR = [RefSurfaceWhiteRef RefSurfaceGMExt RefSurfaceGrey RefSurfaceGMClassic];

TestHRf4 = table2array(T(1, 3:end));
TestHRf56 = table2array(T(2, 3:end));
TestHRf8 = table2array(T(3,  3:end));
TestHRf56_8 = table2array(T(4, 3:end));
TestHRf56_30 = table2array(T(5, 3:end));

%% Curve fit the data
% Set up fittype and options.
% Ref is the luminance values, test are the digital values of spheron hdr
% image

ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Lower = [-Inf 0];
opts.Upper = [Inf 0];

[xData, yData] = prepareCurveData( RefSurfaceHR, TestHRf4 );
% Fit model to data.
[fitresultHR{1}, gof(1)] = fit( xData, yData, ft, opts );

[xData, yData] = prepareCurveData( RefSurfaceHR, TestHRf56 );
% Fit model to data.
[fitresultHR{2}, gof(2)] = fit( xData, yData, ft, opts );

[xData, yData] = prepareCurveData( RefSurfaceHR, TestHRf8 );
% Fit model to data.
[fitresultHR{3}, gof(3)] = fit( xData, yData, ft, opts );

[xData, yData] = prepareCurveData( RefSurfaceHR, TestHRf56_8 );
% Fit model to data.
[fitresultHR{4}, gof(4)] = fit( xData, yData, ft, opts );

[xData, yData] = prepareCurveData( RefSurfaceHR, TestHRf56_30 );
% Fit model to data.
[fitresultHR{5}, gof(5)] = fit( xData, yData, ft, opts );


vecLum = 10 : 10 : 700;
ydatHRf4 = fitresultHR{1}(vecLum);
ydatHRf56 = fitresultHR{2}(vecLum);
ydatHRf8 = fitresultHR{3}(vecLum);
ydatHRf56_8 = fitresultHR{4}(vecLum);
ydatHRf56_30 = fitresultHR{5}(vecLum);



%% plot results
figure;

subplot(311)
title('Baseline XYZ predictions')
[RefSurfaceHR_sorted ref_order] = sort(RefSurfaceHR);
line(RefSurfaceHR(ref_order),TestHRf4(ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.0 0.6 0.0]); hold on;
h = line(vecLum, ydatHRf4, 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),TestHRf56(ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.2 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf56, 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),TestHRf8(ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.6 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf8, 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),TestHRf56_8(ref_order), 'LineStyle', '-.', 'LineWidth', 1, 'Marker', '+', 'MarkerSize', 8, 'Color', [0.0 0.6 0.0]); hold on; 
h = line(vecLum, ydatHRf56_8, 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),TestHRf56_30(ref_order), 'LineStyle', '-.', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 8, 'Color', [0.6 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf56_30, 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

xlabel('Absolute ground truth luminance (nits)');
ylabel('Y output (after RGB to XYZ conversion)');
box on; grid on;
set(gca, 'YScale', 'log', 'XScale', 'log');

legend('f4 - 1/15', 'f5.6 - 1/15', 'f8 - 1/15', 'f5.6 - 1/8', 'f5.6 - 1/30','location','NorthWest');
set(gca,'FontSize',14);
   
% fprintf('High Res, For aperture f 4 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{1}.p1, 1/fitresultHR{1}.p1)
% fprintf('High Res, For aperture f 5.6 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{2}.p1, 1/fitresultHR{2}.p1)
% fprintf('High Res, For aperture f 8 slope is to %.4f, hence k factor is %.2f\n\n', fitresultHR{3}.p1, 1/fitresultHR{3}.p1)   

fprintf('High Res, For aperture f 4 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{1}.p1, 1/fitresultHR{1}.p1)
fprintf('High Res, For aperture f 5.6 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{2}.p1, 1/fitresultHR{2}.p1)
fprintf('High Res, For aperture f 8 slope is to %.4f, hence k factor is %.2f\n\n', fitresultHR{3}.p1, 1/fitresultHR{3}.p1)

% saving the k factor multiplier for later
k_fac(1) = 1/fitresultHR{1}.p1;
k_fac(2) = 1/fitresultHR{2}.p1;
k_fac(3) = 1/fitresultHR{3}.p1;

fprintf('High Res, intensity change btw f 4 and f 5.6 is %.2f\n', (1/fitresultHR{2}.p1)/(1/fitresultHR{1}.p1))
fprintf('High Res, intensity change btw f 5.6 and f 8 is %.2f\n\n', (1/fitresultHR{3}.p1)/(1/fitresultHR{2}.p1))


subplot(312)
title('Recovered luminance')
% obtain the multiplier that is supposed to convert pixel values to luminance
kMult = get_Kmult();
% capture parameters for each configuration, based on legend below
parameters = [4, 1/15; 5.6, 1/15; 8, 1/15; 5.6, 1/8; 5.6, 1/30];
% exposure value calculated for each parameter combination
EV = 2.^(get_EV(parameters(:,1), parameters(:,2)));
% final linear luminance multiplier obtained for each combination
M = kMult*EV;
% ground truth luminance measurements
R = RefSurfaceHR;
% estimated luminance Y of XYZ measurements using the Spheron Y values recovered using MIMP as detailed in report from May'21
% the luminance values are adjusted using the multiplier/EV number we just calculated
LuminanceEstimate(1,:) = TestHRf4    .*M(1);
LuminanceEstimate(2,:) = TestHRf56   .*M(2);
LuminanceEstimate(3,:) = TestHRf8    .*M(3);
LuminanceEstimate(4,:) = TestHRf56_8 .*M(4);
LuminanceEstimate(5,:) = TestHRf56_30.*M(5);

line(RefSurfaceHR(ref_order),LuminanceEstimate(1,ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.0 0.6 0.0]); hold on;
h = line(vecLum, ydatHRf4.*M(1), 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),LuminanceEstimate(2,ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.2 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf56.*M(2), 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),LuminanceEstimate(3,ref_order), 'LineStyle', '--', 'LineWidth', 1, 'Marker', '*', 'MarkerSize', 8, 'Color', [0.6 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf8.*M(3), 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),LuminanceEstimate(4,ref_order), 'LineStyle', '-.', 'LineWidth', 1, 'Marker', '+', 'MarkerSize', 8, 'Color', [0.0 0.6 0.0]); hold on; 
h = line(vecLum, ydatHRf56_8.*M(4), 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

line(RefSurfaceHR(ref_order),LuminanceEstimate(5,ref_order), 'LineStyle', '-.', 'LineWidth', 1, 'Marker', 'o', 'MarkerSize', 8, 'Color', [0.6 0.2 0.2]); hold on; 
h = line(vecLum, ydatHRf56_30.*M(5), 'LineStyle', '-', 'LineWidth', 1.5, 'Marker', 'none','Color', [0.4 0.4 0.4]);
set(get(get(h(1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

xval = 0.1:0.01:10000; yval = ones(size(xval));
plot(xval, xval, '--b', 'LineWidth', 1.5);

xlabel('Absolute ground truth luminance (nits)');
ylabel('Y output (after RGB to XYZ conversion)');
box on; grid on;
set(gca, 'YScale', 'log', 'XScale', 'log');


legend('f4 - 1/15', 'f5.6 - 1/15', 'f8 - 1/15', 'f5.6 - 1/8', 'f5.6 - 1/30', 'reference','location','SouthEast');
set(gca,'FontSize',14);

fprintf('High Res, For aperture f 4 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{1}.p1, 1/fitresultHR{1}.p1)
fprintf('High Res, For aperture f 5.6 slope is to %.4f, hence k factor is %.2f\n', fitresultHR{2}.p1, 1/fitresultHR{2}.p1)
fprintf('High Res, For aperture f 8 slope is to %.4f, hence k factor is %.2f\n\n', fitresultHR{3}.p1, 1/fitresultHR{3}.p1)

fprintf('High Res, intensity change btw f 4 and f 5.6 is %.2f\n', (1/fitresultHR{2}.p1)/(1/fitresultHR{1}.p1))
fprintf('High Res, intensity change btw f 5.6 and f 8 is %.2f\n\n', (1/fitresultHR{3}.p1)/(1/fitresultHR{2}.p1))


% now let's see how proportionally accurate the predictions are
subplot(313)
title('Proportional error')

% find the proportional error
factor = R./LuminanceEstimate;
plot(R(ref_order), factor(:,ref_order), 'LineWidth', 1.5);
set(gca,'XScale', 'log'); hold on;
box on; grid on; 
ylim([0 1.4]); xlim([1 10000]);
xlabel('Absolute ground truth luminance (nits)');
ylabel('Ground truth to predicted ratio');

xval = 0.1:0.01:10000; yval = ones(size(xval));
plot(xval, yval, '--b', 'LineWidth', 1.5);
legend('f4 - 1/15', 'f5.6 - 1/15', 'f8 - 1/15', 'f5.6 - 1/8', 'f5.6 - 1/30', 'reference','location','SouthEast');
title('Ground truth to prediction ratio');
set(gca,'FontSize',14);