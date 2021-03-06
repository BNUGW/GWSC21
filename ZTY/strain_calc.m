function strain = strain_calc(hp,hc,theta,phi)
%Input :
%       hp  :h_+
%       hc  :h_x
%       theta:  source direction 
%       phi  :  source direction
addpath '../GWSIG'
[fp,fc] = detframefpfc(theta,phi);
strain = hp * fp + hc * fc;
end

