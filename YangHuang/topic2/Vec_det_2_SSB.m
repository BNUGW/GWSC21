function SSB_vec = Vec_det_2_SSB(det_vec,t)
%VEC_DET_2_SSB Summary of this function goes here
%   Detailed explanation goes here
%rotation1:
rot_1 = [   1,  0,          0;
            0,  1/2,        sqrt(3)/2;
            0,  -sqrt(3)/2, 1/2];
    
%rotation2:
w = 2*pi/(365*24*3600);
rot_2 = [   cos(w * t),-sin(w * t),0;
            sin(w * t),cos(w * t),0
            0,              0,          1];

SSB_vec = rot_2 * rot_1 * det_vec';
SSB_vec = SSB_vec';
end


