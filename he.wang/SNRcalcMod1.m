%% How to normalize a signal for a given SNR
% We will normalize a signal such that the Likelihood ratio (LR) test for it has
% a given signal-to-noise ratio (SNR) in noise with a given Power Spectral 
% Density (PSD). [We often shorten this statement to say: "Normalize the
% signal to have a given SNR." ]

%%
clear
% Path to folder containing signal and noise generation codes
addpath ../SIGNALS/
addpath ../NOISE/
addpath ../DETEST/

%%
% This is the target SNR for the LR
snr = 10;

%%
% Data generation parameters
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;


%%
% Generate the signal that is to be normalized
a1=10;
a2=3;
a3=3;
% Amplitude value does not matter as it will be changed in the normalization
A = 1; 
sigVec = crcbgenqcsig(timeVec,1,[a1,a2,a3]);

%%
% We will use the noise PSD used in colGaussNoiseDemo.m but add a constant
% to remove the parts that are zero. (Exercise: Prove that if the noise PSD
% is zero at some frequencies but the signal added to the noise is not,
% then one can create a detection statistic with infinite SNR.)
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;

%%
% Generate the PSD vector to be used in the normalization. Should be
% generated for all positive DFT frequencies. 

% dataLen = nSamples/sampFreq;
% kNyq = floor(nSamples/2)+1;
% posFreq = (0:(kNyq-1))*(1/dataLen);
T = nSamples/sampFreq; % total time
df = 1/T; % frequency resolution
Nyq = sampFreq/2; % Nyquist frequency
f = 0:df:Nyq;
psdPosFreq = noisePSD(f);
figure;
plot(f,psdPosFreq);
axis([0,f(end),0,max(psdPosFreq)]);
title('Designed PSD');
xlabel('Frequency (Hz)');
ylabel('PSD ((data unit)^2/Hz)');

%% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,sampFreq,psdPosFreq);
% Normalize signal to specified SNR
sigVec = snr*sigVec/sqrt(normSigSqrd);

%% Test
%Obtain LLR values for multiple noise realizations
nH0Data = 1000;
llrH0 = zeros(1,nH0Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[f(:),psdPosFreq(:)],100,sampFreq);
    llrH0(lp) = innerprodpsd(noiseVec,sigVec,sampFreq,psdPosFreq);
end
%Obtain LLR for multiple data (=signal+noise) realizations
nH1Data = 1000;
llrH1 = zeros(1,nH1Data);
for lp = 1:nH0Data
    noiseVec = statgaussnoisegen(nSamples,[f(:),psdPosFreq(:)],100,sampFreq);
    % Add normalized signal
    dataVec = noiseVec + sigVec;
    llrH1(lp) = innerprodpsd(dataVec,sigVec,sampFreq,psdPosFreq);
end
%%
% Signal to noise ratio estimate
estSNR = (mean(llrH1)-mean(llrH0))/std(llrH0);
disp("Estimated SNR is:" + estSNR);

figure;
histogram(llrH0);
hold on;
histogram(llrH1);
xlabel('LLR');
ylabel('Counts');
legend('H_0','H_1');
title(['Estimated SNR = ',num2str(estSNR)]);

%%
% A noise realization
figure;
plot(timeVec,noiseVec);
xlabel('Time (sec)');
ylabel('Noise');
%%
% A data realization
figure;
plot(timeVec,dataVec);
hold on;
plot(timeVec,sigVec);
legend('Data','Signale');
xlabel('Time (sec)');
ylabel('Data');

% periodgram
fftSig = fft(sigVec);
fftSig = fftSig(1:floor(nSamples/2)+1);
fftData = fft(dataVec);
fftData = fftData(1:floor(nSamples/2)+1);
figure;
plot(f,abs(fftSig),'r');
hold on;
plot(f,abs(fftData),'b');
axis([0,f(end),0 inf]);
title('Periodgram');
xlabel('Frequency [Hz]');
ylabel('Periodgram');
legend('Signal','Data');

% spectrogram
[s,f,t] = spectrogram(dataVec,64,60,[],sampFreq);
figure;
imagesc(t,f,abs(s));
title('Spectrogram')
xlabel('Time [s]')
ylabel('Frequency [Hz]')