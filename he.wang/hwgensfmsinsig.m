function sigVec = hwgensfmsinsig(dataX,snr,f0,f1,ta)
% Generate a step FM sinusoid signal
% S = HWGENSFMSIG(X,SNR,F0,F1,T)
% Generates a step FM sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F0 and F1 are the frequency of 
% the modulator and carrier sinusoid. T is the boundary of the step time.

%He Wang, Feb 2021

sigVec = sin(2*pi*f1*(dataX - ta) + 2*pi*f0*dataX*ta);
sigVec(dataX <= ta) = sin(2*pi*f0*dataX(dataX <= ta));
sigVec = snr*sigVec/norm(sigVec);

