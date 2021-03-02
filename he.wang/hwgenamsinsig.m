function sigVec = hwgenamsinsig(dataX,snr,f0,f1,phi0)
% Generate an amplitude modulated (AM) sinusoid
% S = HWGENAMSIG(X,SNR,F0,F1,P)
% Generates an AM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F1 is the frequency of 
% the carrier sinusoid and (phi0, F0) is the (phase, frequency) of the 
% modulator sinusoid.

%He Wang, Feb 2021

sigVec = cos(2*pi*f1*dataX) .* sin(f0*dataX + phi0);
sigVec = snr*sigVec/norm(sigVec);