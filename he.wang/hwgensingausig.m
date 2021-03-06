function sigVec = hwgensingausig(dataX,snr,f0,phi0,t0,sigma)
% Generate a sine-Gaussian signal
% S = HWGENSINGAUSIG(X,SNR,F,P,T0,SIGMA)
% Generates a sine-Gaussian signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F and P are the central
% frequency and phase of the sine-Gaussian signal respectively. 
% T0 and SIGMA^2 are the mean and variance of the Gaussian amplitude.

%He Wang, Feb 2021

sigVec = exp(-(dataX-t0).^2/2/sigma) .* sin(2*pi*f0*dataX + phi0);
sigVec = snr*sigVec/norm(sigVec);
