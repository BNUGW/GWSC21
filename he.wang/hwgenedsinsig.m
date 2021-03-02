function sigVec = hwgenedsinsig(dataX,snr,f0,tau,phi0,ta,L)
% Generate an exponentially damped sinusoid
% S = HWGENEDSINSIG(X,SNR,F0,TAU,P,T,L)
% Generates an exponentially damped sinusoid signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. (F0, P) is the (frequency
% , phase) of the signal. TAU is the coefficient of the amplitude part.
% (T, L) is the (starting, ending) time for the signal.

%He Wang, Feb 2021

sigVec = exp(-(dataX-ta)/tau) .* sin(2*pi*f0*dataX + phi0);
sigVec = snr*sigVec/norm(sigVec);
sigVec(dataX < ta) = 0;
sigVec(dataX > ta+L) = 0;