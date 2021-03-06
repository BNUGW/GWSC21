addpath '../GWSIG'

%% Test harness for FORMULAFP and SKYPLOT
%Azimuthal angle
phiVec = 0:0.1:(2*pi);
%Polar angle
thetaVec = 0:0.1:pi;

%Function handle: F+ and Fxfrom formula
fp = @(x,y) formulafp(x,y);
fc = @(x,y) formulafc(x,y);

subplot(1,2,1)
skyplot(phiVec,thetaVec,fp);
title('F_+')
colorbar
axis equal
subplot(1,2,2)
skyplot(phiVec,thetaVec,fc);
title('F_x')
axis equal;
colorbar