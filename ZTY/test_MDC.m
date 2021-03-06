%% Topic 6

addpath ../SIGNALS
addpath ../NOISE
addpath ../DETEST
addpath ../../SDMBIGDAT19/CODES


%% Parameters for data realization
% Number of samples and sampling frequency.
load('../MDC/TrainingData.mat')
load('../MDC/analysisData.mat')
nSamples = length(dataVec);
timeVec = (0:(nSamples-1))/sampFreq;

%% Supply PSD values
% This is the noise psd we will use.
[psdPosFreq,posFreq]=pwelch(trainData,nSamples,[],[],sampFreq);
% dataLen = nSamples/sampFreq;
% kNyq = floor(nSamples/2)+1;
% posFreq = (0:(kNyq-1))*(1/dataLen);
% psdPosFreq = noisePSD(posFreq);

% figure;
% plot(f,psd,f,psdPosFreq);
% xlabel('Frequency (Hz)');
% ylabel('PSD');
%% Input Param Struct Initialization
in_params = struct( 'rmin',         [40,    1,  1],        ...
                    'rmax',         [100,   50, 15],    ...
                    'dataX',        timeVec,        ...
                    'dataXSq',      timeVec.^2,     ...
                    'dataXCb',      timeVec.^3,     ...
                    'sampFreq',     sampFreq,       ...
                    'psdPosFreq',   psdPosFreq',    ...
                    'dataY',        dataVec         ...
                   );
              
pso_params = struct('maxSteps',2000);

nRuns = 8;

O = glrtqcpso(in_params,pso_params,nRuns);

%% plot results
figure
hold on
plot(timeVec,dataVec,'.','MarkerSize',12)
plot(timeVec,O.bestSig,'LineWidth',1)
legend('data','bestSig')
xlabel('time (s)')
hold off
disp(['Estimated parameters: a1=',num2str(O.bestQcCoefs(1)),...
                             '; a2=',num2str(O.bestQcCoefs(2)),...
                             '; a3=',num2str(O.bestQcCoefs(3))]);
