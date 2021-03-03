
clear; clc; close all;
addpath ./SDMBIGDAT19/CODES/
addpath ../MDC/

%% Load data
TrainingData = load('TrainingData.mat')';
analysisData = load('analysisData.mat')';

%% Preparing
dataY = analysisData.dataVec;
% Data length
nSamples = length(dataY); % 2048
% Sampling frequency
Fs = analysisData.sampFreq; % 1024

% Search range of phase coefficients
rmin = [40, 1, 1];
rmax = [100, 50, 15];

%% Noise realization: PSD estimated from TrainingData
dt = 1/Fs;
t = 0:dt:(nSamples-1)*dt;
T = nSamples/Fs;
df = 1/T;
Nyq = Fs/2; % Nyquist frequency
f = 0:df:Nyq; % Not used...(Herb)
% psdPosFreq = pwelch(TrainingData.trainData, nSamples,[],[],Fs)'; 
[pxx,f] = pwelch(TrainingData.trainData, Fs/2,[],[],Fs);

% Smooth the PSD estimate
smthOrdr = 10;
b = ones(1,smthOrdr)/smthOrdr;
pxxSmth = filtfilt(b,1,pxx);

% PSD must be supplied at DFT frequencies.
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*Fs/nSamples;
psdPosFreq = interp1(f,pxxSmth,posFreq);

% Number of independent PSO runs
nRuns = 8;

% Plot PSDs for the noise and noise + signal.
figure;
hold on;
plot(f,pxx);
plot(f,pxxSmth);
[pxxY,f]=pwelch(dataY, 256,[],[],Fs);
plot(f,pxxY);
xlabel('Frequency (Hz)');
ylabel('PSD');
legend('noise', 'noise (smoth)', 'noise + signal');

%% PSO
% Input parameters for CRCBQCHRPPSO
inParams = struct('dataX', t,...
                  'dataY', dataY,...
                  'dataXSq',t.^2,...
                  'dataXCb',t.^3,...
                  'psdPosFreq',psdPosFreq,...
                  'sampFreq',Fs,...
                  'rmin',rmin,...
                  'rmax',rmax);
% CRCBQCHRPPSO runs PSO on the CRCBQCHRPFITFUNC fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.
outStruct = crcbqcpsopsd(inParams, struct('maxSteps', 2000), nRuns);


%% Plots
figure;
hold on;
plot(t,dataY,'.');
% plot(t,dataVec);
for lpruns = 1:nRuns
    plot(t,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(t,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('noise+signal','signal','estSig1','estSig2','estSig3','estSig4','estSig5','estSig6','estSig7','estSig8','BestSig');
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);

