%% Topic 5

addpath ../SIGNALS
addpath ../NOISE
addpath ../DETEST
addpath ../../SDMBIGDAT19/CODES


%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 512;
sampFreq = 512;
timeVec = (0:(nSamples-1))/sampFreq;

%% Supply PSD values
% This is the noise psd we will use.
noisePSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

%% Data realization
a1 = 10;
a2 = 3;
a3 = 3;
A = 10;
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
sig4data = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
% Signal normalized to SNR=10
[sig4data,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,10);
dataVec = noiseVec+sig4data;

%% Input Param Struct Initialization
in_params = struct( 'rmin',         [1,1,1],        ...
                    'rmax',         [180,10,10],    ...
                    'dataX',        timeVec,        ...
                    'dataXSq',      timeVec.^2,     ...
                    'dataXCb',      timeVec.^3,     ...
                    'sampFreq',     sampFreq,       ...
                    'psdPosFreq',   psdPosFreq,     ...
                    'dataY',        dataVec         ...
                   );
              
pso_params = struct('maxSteps',1000);

nRuns = 8;

O = glrtqcpso(in_params,pso_params,nRuns);

%% plot results
figure
hold on
plot(timeVec,dataVec,'.')
plot(timeVec,dataVec-noiseVec)
plot(timeVec,estSig)
legend('data','signal','bestSig')
xlabel('time (s)')


% 
% estSig = crcbgenqcsig(timeVec,1,O.bestQcCoefs);
% [templateVec,~] = normsig4psd(estSig,sampFreq,psdPosFreq,1);
% estAmp = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
% [estSig,~]=normsig4psd(sig4data,sampFreq,psdPosFreq,estAmp);




