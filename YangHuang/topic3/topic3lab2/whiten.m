function outNoise = whiten(data,psdVals,fltrOrdr,sampFreq)
%根据指定的psd生成噪声

%Generate a realization of stationary Gaussian noise with given 2-sided PSD
%Y = STATGAUSSNOISEGEN(N,PSD,O,Fs)
%Generates a realization Y of stationary gaussian noise with a target
%2-sided power spectral density given by PSD. Fs is the sampling frequency
%of Y. PSD is an M-by-2 matrix containing frequencies and the corresponding
%PSD values in the first and second columns respectively. The frequencies
%must start from 0 and end at Fs/2. The order of the FIR filter to be used
%is given by O.

%Soumya D. Mohanty, Mar 2019

% Design FIR filter with T(f)= square root of target PSD
freqVec = psdVals(:,1);
sqrtPSD = sqrt(psdVals(:,2));
b = fir2(fltrOrdr,freqVec/(sampFreq/2),sqrtPSD);

%%
% Generate a WGN realization and pass it through the designed filter
% (Comment out the line below if new realizations of WGN are needed in each run of this script)
% rng('default'); 
% inNoise = randn(1,nSamples);
outNoise = sqrt(sampFreq)*fftfilt(b,data);
%白高斯噪声进行滤波器过滤后，再乘以采样率平方根，就得到目标噪声

