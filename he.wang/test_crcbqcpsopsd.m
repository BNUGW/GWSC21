
clear

addpath ./SDMBIGDAT19/CODES/

%% Minimize the fitness function CRCBQCFITFUNC using PSO
% Data length
nSamples = 512;
% Sampling frequency
Fs = 512;
% Signal to noise ratio of the true signal
snr = 10;
% Phase coefficients parameters of the true signal
a1 = 10;
a2 = 3;
a3 = 3;

% Search range of phase coefficients
rmin = [1, 1, 1];
rmax = [18, 10, 10];

% Noise realization: Toy PSD
dt = 1/Fs;
t = 0:dt:(nSamples-1)*dt;
T = nSamples/Fs;
df = 1/T;
Nyq = Fs/2; % Nyquist frequency
f = 0:df:Nyq;
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
psdPosFreq = noisePSD(f);

% Number of independent PSO runs
nRuns = 8;
%% Do not change below
% Generate data realization
dataX = (0:(nSamples-1))/Fs;
% Reset random number generator to generate the same noise realization,
% otherwise comment this line out
% rng('default');
% Generate signal realization
% [sigVec, sig] = crcbgenqcsig(dataX,snr,[a1,a2,a3]);
phaseVec = a1*dataX + a2*dataX.^2 + a3*dataX.^3;
sigVec = sin(2*pi*phaseVec);
% sigVec = sigVec/norm(sigVec);

% Calculation of the norm
% Norm of signal squared is inner product of signal with itself
normSigSqrd = innerprodpsd(sigVec,sigVec,Fs,psdPosFreq);
% Normalize signal to specified SNR
dataVec = snr*sigVec/sqrt(normSigSqrd);
% Data (=signal+noise) realizations
noiseVec = statgaussnoisegen(nSamples,[f(:),psdPosFreq(:)],100,Fs);
% Add normalized signal
dataY = noiseVec + dataVec;

% Input parameters for CRCBQCHRPPSO
inParams = struct('dataX', dataX,...
                  'dataY', dataY,...
                  'dataXSq',dataX.^2,...
                  'dataXCb',dataX.^3,...
                  'psdPosFreq',psdPosFreq,...
                  'sampFreq',Fs,...
                  'rmin',rmin,...
                  'rmax',rmax);
% CRCBQCHRPPSO runs PSO on the CRCBQCHRPFITFUNC fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.
% outStruct = crcbqcpso(inParams,struct('maxSteps',1000),nRuns);
outStruct = crcbqcpsopsd(inParams, struct('maxSteps', 1000), nRuns);

%%
% Plots
figure;
hold on;
plot(dataX,dataY,'.');
plot(dataX,dataVec);
for lpruns = 1:nRuns
    plot(dataX,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(dataX,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
legend('noise+signal','signal','estSig1','estSig2','estSig3','estSig4','estSig5','estSig6','estSig7','estSig8','BestSig')
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);

