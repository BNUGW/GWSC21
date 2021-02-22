function sigVec = hy_gensinsig(dataX,snr,qcCoefs)
% Generate a sinusoidal signal
% S = gensinsig(X,SNR,C)
% Generates a sinusoidal signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S and C is the vector of
% coefficients [f, phi]. f and phi is the frequency and initial phase of
% the sinusoidal signal respectively.

%Yang Huang, Feb 2021

phaseVec = qcCoefs(1)*dataX + qcCoefs(2);
sigVec = sin(2*pi*phaseVec);
sigVec = snr*sigVec/norm(sigVec);


