%% Test harness for FORMULAFP and SKYPLOT
%Azimuthal angle
phiVec = 0:0.1:(2*pi);
%Polar angle
thetaVec = 0:0.1:pi;

%Function handle: F+ from formula
fp = @(x,y) formulafp(x,y);
%Function handle: F+ from formula
fc = @(x,y) formulafc(x,y);

figure;
subplot(2,1,1);
skyplot(phiVec,thetaVec,fp);
title('F_+');colorbar;
axis equal;

subplot(2,1,2);
skyplot(phiVec,thetaVec,fc);
title('F_x');colorbar;
axis equal;
