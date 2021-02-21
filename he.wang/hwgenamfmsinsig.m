function sigVec = hwgenamfmsinsig(dataX,snr,f0,f1,b)
% Generate an AM-FM sinusoid signal
% S = HWGENAMFMSIG(X,SNR,F0,F1,B)
% Generates an AM-FM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F1 is the frequency of 
% the carrier sinusoid and (B, F0) is the (phase, frequency) in the 
% modulator sinusoid part.

%He Wang, Feb 2021

sigVec = cos(2*pi*f1*dataX) .* sin(2*pi*f0*dataX + b*cos(2*pi*f1*dataX));
sigVec = snr*sigVec/norm(sigVec);