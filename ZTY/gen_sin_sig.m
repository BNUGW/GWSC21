function sig = gen_sin_sig(t,f0,A,phi0)
%generate sinusoids signal
%   t   : time sequence
%   f0  : frequency
%   A   : amplitude
%   phi0: initial phase

%Tian-Yu Zhao Feb. 22 2021
sig = A * sin(2*pi * f0 * t + phi0);
end