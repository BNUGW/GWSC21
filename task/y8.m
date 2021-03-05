clear
%% Minimize the fitness function CRCBQCFITFUNC using PSO
% Data length
load('/Users/alliswell48/Downloads/引力波数/GWSC/MDC/TrainingData.mat');

load('/Users/alliswell48/Downloads/引力波数/GWSC/MDC/analysisData.mat');
dataY1=dataVec;
outN=trainData;





nSamples = length(dataVec);  %g
% Sampling frequency
Fs= sampFreq;  
%sampFreq=512;



% Search range of phase coefficients
rmin = [40,1,1];  %gou
rmax = [100, 50, 15]; %gou

% Number of independent PSO runs
nRuns = 8;  %gou
%% Do not change below
% Generate data realization
dataX = (0:(nSamples-1))/Fs;  %g
% Reset random number generator to generate the same noise realization,
% otherwise comment this line out
rng('default');
% Generate data realization
%[dataY1, sig,outN] = genqcdata(dataX,snr,[a1,a2,a3],Fs,nSamples);



%[pxx,f]=pwelch(outN, 256,[],[],Fs);
[pxx,f]=pwelch(outN, Fs/2,[],[],Fs);  %gou
%why129 only1/4,use
%which??????guji,jiexi?????


%% Smooth the PSD estimate
smthOrdr = 10;  %gou
b = ones(1,smthOrdr)/smthOrdr;  %g
pxxSmth = filtfilt(b,1,pxx);  %g

psdVec=pxxSmth;  %g


fltrOrdr=100;
%dataY=whiten(f,psdVec,fltrOrdr,Fs,dataY1);
%Target PSD given by the inline function handle
%targetPSD = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625+1;
%targetPSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000;


[pxx,f]=pwelch(outN,Fs/2,[],[],Fs);
%semilogy(f,pxx);
%%
% Smooth the PSD estimate
smthOrdr = 10;
b = ones(1,smthOrdr)/smthOrdr;
pxxSmth = filtfilt(b,1,pxx);
%hold on;
%semilogy(f,pxxSmth);

%% Design whitening filter
whtB = fir2(100,f/(sampFreq/2),1./sqrt(pxxSmth));

%%
% Verify whitening. PSD of whitened data.
whtTrainData = fftfilt(whtB,trainData);
%figure;
%pwelch(whtTrainData, sampFreq/2, [], [], sampFreq);

%% Whiten the analysis data

%dataY = fftfilt(whtB,dataY1);
dataY=dataY1;%gaigaigai



nSamples = length(dataY1);  %g
timeVec = (0:(nSamples-1))/Fs; %g
%%
% PSD must be supplied at DFT frequencies.
kNyq = floor(nSamples/2)+1;  %g
posFreq = (0:(kNyq-1))*Fs/nSamples;   %g
psdVecEst = interp1(f,pxx,posFreq);    %g



%tmpltVec = normsig4psd(sigVec,sampFreq,psdVecEst,1);
%snr = innerprodpsd(dataY,tmpltVec,sampFreq,psdVecEst);

%Plot PSD

%freqVec = (0:(floor(nSamples/2)))*Fs;
%psdVec = targetPSD(freqVec);


% Input parameters for CRCBQCHRPPSO
inParams = struct('dataX', dataX,...
                  'dataY', dataY,...
                  'dataXSq',dataX.^2,...
                  'dataXCb',dataX.^3,...
                  'rmin',rmin,...
                  'rmax',rmax,...
                  'sampFreq',Fs,...
                  'psdVec',psdVecEst,...
                  'snr',1);  %g
                  %1
% CRCBQCHRPPSO runs PSO on the CRCBQCHRPFITFUNC fitness function. As an
% illustration of usage, we change one of the PSO parameters from its
% default value.% sampFreq, psdVec, snr .   %2
outStruct = crcbqcpso8(inParams,struct('maxSteps',2000),nRuns);   %g

%%
% Plots
figure;
hold on;
plot(dataX,dataY1,'.');
%plot(dataX,sig);
for lpruns = 1:nRuns
    plot(dataX,outStruct.allRunsOutput(lpruns).estSig,'Color',[51,255,153]/255,'LineWidth',4.0);
end
plot(dataX,outStruct.bestSig,'Color',[76,153,0]/255,'LineWidth',2.0);
disp(['Estimated parameters: a1=',num2str(outStruct.bestQcCoefs(1)),...
                             '; a2=',num2str(outStruct.bestQcCoefs(2)),...
                             '; a3=',num2str(outStruct.bestQcCoefs(3))]);

