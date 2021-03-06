function sigVec = hwgenltcsig(dataX,snr,f0,f1,phi0,ta,L)
% Generate an linear transient chirp signal
% S = HWGENLTCSIG(X,SNR,F0,F1,P,T,L)
% Generates an linear transient chirp signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S. F0 and F1 are the 
% coefficients for frequency of the signal. P is the phase of the signal. 
% (T, L) is the (starting, ending) time for the signal.

%He Wang, Feb 2021

sigVec = sin(2*pi*(f0*(dataX-ta) +f1*(dataX-ta).^2) + phi0);
sigVec = snr*sigVec/norm(sigVec);
sigVec(dataX < ta) = 0;
sigVec(dataX > ta+L) = 0;