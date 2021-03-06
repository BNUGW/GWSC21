function sigVec = hwgenfmsinsig(dataX,snr,f0,f1,b)
% Generate a frequency modulated (FM) sinusoid signal
% S = HWGENFMSIG(X,SNR,F0,F1,B)
% Generates a FM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F0 is the frequency of 
% the carrier sinusoid and (B, F1) is the (amplitude, frequency) of the 
% modulator sinusoid.

%He Wang, Feb 2021

sigVec = sin(2*pi*f0*dataX + b*cos(2*pi*f1*dataX));
sigVec = snr*sigVec/norm(sigVec);