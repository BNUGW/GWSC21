function [xVec,yVec] = wave_frame_base_vec_in_det_frame(polAngleTheta,polAnglePhi,Psi)
%DET_FRAME_BASE_VEC Summary of this function goes here
%   Detailed explanation goes here
addpath '../GWSIG'

%Number of locations requested
nLocs = length(polAngleTheta);
if length(polAnglePhi) ~= nLocs
    error('Number of theta and phi values must be the same');
end

%Obtain the components of the unit vector pointing to the source location
sinTheta = sin(polAngleTheta(:));
vec2Src = [sinTheta.*cos(polAnglePhi(:)),...
           sinTheta.*sin(polAnglePhi(:)),...
           cos(polAngleTheta(:))];
       
%Get the wave frame vector components (for multiple sky locations if needed)
xVec = vcrossprod(repmat([0,0,1],nLocs,1),vec2Src);
yVec = vcrossprod(xVec,vec2Src);
%Normalize wave frame vectors
for lpl = 1:nLocs
    xVec(lpl,:) = xVec(lpl,:)/norm(xVec(lpl,:));
    yVec(lpl,:) = yVec(lpl,:)/norm(yVec(lpl,:));
end
%rotation: multiply a rotation matrix
for lpl = 1:nLocs
    rot_mat = [cos(Psi(lpl)),sin(Psi(lpl));
                -sin(Psi(lpl)),cos(Psi(lpl))];
    tmp = rot_mat * [xVec(lpl,:);yVec(lpl,:)];
    xVec(lpl,:) = tmp(1,:);
    yVec(lpl,:) = tmp(2,:);
end
end

