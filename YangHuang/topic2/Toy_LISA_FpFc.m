function [fPlus,fCross] = Toy_LISA_FpFc(polAngleTheta,polAnglePhi,Psi,t)
%TOY_LISA_FPFC Summary of this function goes here
%   Detailed explanation goes here
addpath '../GWSIG'    
%Get the wave frame vector components (for multiple sky locations if needed)
[xVec,yVec] = wave_frame_base_vec_in_det_frame(polAngleTheta,polAnglePhi,Psi);
%to SSB frame
nLocs = length(polAngleTheta);
nt = length(t);
xVec_t = zeros(nLocs,3,nt);
yVec_t =xVec_t;
for i = 1:nt
for lpl = 1:nLocs
    tmp1 = Vec_det_2_SSB(xVec(lpl,:),t(i));
    tmp2 = Vec_det_2_SSB(yVec(lpl,:),t(i));
    xVec_t(lpl,:,i) = tmp1;
    yVec_t(lpl,:,i) = tmp2;
end
end

%arm coponent n1 n2 n3 in det frame
l = 2.5e9/sqrt(3);
w = 2*pi/(365*24*3600); %per year

a = l * [cos(w*t)',sin(w*t)',zeros(nt,1)];
b = l * [cos(w*t + 2*pi/3)',sin(w*t + 2*pi/3)',zeros(nt,1)];
c = l * [cos(w*t + 4*pi/3)',sin(w*t + 4*pi/3)',zeros(nt,1)];

n1 = b - c;
n2 = c - a;
n3 = a - b;

for i = 1:nt
    tmp1 = Vec_det_2_SSB(n1(i,:),t(i));
    tmp2 = Vec_det_2_SSB(n2(i,:),t(i));
    tmp3 = Vec_det_2_SSB(n3(i,:),t(i));
    n1(i,:) = tmp1/norm(tmp1);
    n2(i,:) = tmp2/norm(tmp2);
    n3(i,:) = tmp3/norm(tmp3);
end

%Detector tensor 
detTensor1 = zeros(nt,3,3);
detTensor2 = detTensor1;
for i = 1:nt
    detTensor1(i,:,:) = (n1(i,:)'*n1(i,:) - n2(i,:)'*n2(i,:))/2;
    detTensor2(i,:,:) = (n1(i,:)'*n1(i,:) + n2(i,:)'*n2(i,:)...
        -2 * (n3(i,:)'*n3(i,:)))/(2*sqrt(3));
end
fPlus = zeros(nLocs,nt,2);
fCross = zeros(nLocs,nt,2);
%For each location ...
%waveTensor = zeros(nt,3,3,3);
%for j =1:2
for lpl = 1:nLocs
for i =1:nt
    %ePlus contraction with detector tensor
    waveTensor = xVec_t(lpl,:,i)'*xVec_t(lpl,:,i)-yVec_t(lpl,:,i)'*yVec_t(lpl,:,i);
    detTensor = detTensor1(i,:,:);
    fPlus(lpl,i,1) = sum(waveTensor(:).*detTensor(:));
    detTensor = detTensor2(i,:,:);
    fPlus(lpl,i,2) = sum(waveTensor(:).*detTensor(:));
    %eCross contraction with detector tensor
    waveTensor = xVec_t(lpl,:,i)'*yVec_t(lpl,:,i)+yVec_t(lpl,:,i)'*xVec_t(lpl,:,i);
    detTensor = detTensor1(i,:,:);
    fCross(lpl,i,1) = sum(waveTensor(:).*detTensor(:));
    detTensor = detTensor1(i,:,:);
    fCross(lpl,i,2) = sum(waveTensor(:).*detTensor(:));
end
%end
end
end



