function sigVec = hwgensinsig(dataX,snr,f0,phi0)
% Generate a sinusoidal signal
% S = HWGENSINGIG(X,SNR,F,P)
% Generates a sinusoidal signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F and P are the frequency 
% and phase of the sinusoidal signal respectively.

%He Wang, Feb 2021

sigVec = sin(2*pi*f0*dataX + phi0);
sigVec = snr*sigVec/norm(sigVec);
