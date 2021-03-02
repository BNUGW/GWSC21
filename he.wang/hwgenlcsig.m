function sigVec = hwgenlcsig(dataX,snr,f0,f1,phi0)
% Generate a linear chirp signal
% S = HWGENLCSIG(X,SNR,F0,F1,P)
% Generates a linear chirp signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. (F0,F1) and P are the 
% frequency and phase of the linear chirp signal respectively.

%He Wang, Feb 2021

sigVec = sin(2*pi*(f0*dataX + f1*dataX.^2) + phi0);
sigVec = snr*sigVec/norm(sigVec);