%% Estimating significance
clear

d1 = load('../DETEST/data1.txt')';
fs = 1024; % sampling frequency
nSamples = length(d1);
dt = 1/fs;
t = 0:dt:(nSamples-1)*dt;

T = nSamples/fs;
df = 1/T;
Nyq = fs/2; % Nyquist frequency
f = 0:df:Nyq;
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
psdPosFreq = noisePSD(f);

% signal parameters
a1 = 10;
a2 = 3;
a3 = 3;

inParams = struct('dataX', t,...
                  'dataXSq', t.^2,...
                  'dataXCb', t.^3,...
                  'dataY', d1,...
                  'psdPosFreq',psdPosFreq,...
                  'sampFreq',fs);

GLRT1 = glrtqcsig(d1,psdPosFreq,[a1,a2,a3],fs);
GLRT_ssrqc = ssrqc([a1,a2,a3],inParams);