function sigVec = gen_Sine_Gaussian_Sig(dataX,snr,t0,sigma,f0,phi0)
% Generate a Sine-Gaussian signal
% S = gen_Sine_Gaussian_Sig(dataX,snr,t0,sigma,f0,phi0)
% Generates a Sine-Gaussian signal S. X is the vector of
% time stamps at which the samples of the signal are to be computed. SNR is
% the matched filtering signal-to-noise ratio of S and t0 is mean time
% sigma is varience, f0 and phi0 is frequency and phase respectively.

%Tian-Yu Zhao Feb. 22 2021

phaseVec = 2*pi*f0*dataX + phi0;
sigVec = sin(phaseVec);
Ampl = -((dataX - t0).^2)/(2*sigma^2);
Ampl = snr*exp(Ampl)/norm(sigVec);
sigVec = Ampl.*sigVec;
end