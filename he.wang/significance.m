%% Estimating significance
clear

d1 = load('../DETEST/data1.txt')';
d2 = load('../DETEST/data2.txt')';
d3 = load('../DETEST/data3.txt')';

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

GLRT1 = glrtqcsig(d1,psdPosFreq,[a1,a2,a3],fs);
GLRT2 = glrtqcsig(d2,psdPosFreq,[a1,a2,a3],fs);
GLRT3 = glrtqcsig(d3,psdPosFreq,[a1,a2,a3],fs);

nH0data = 10000;
llrH0 = zeros(1,nH0data);
parfor i = 1:nH0data
    noiseVec = statgaussnoisegen(nSamples,[f(:),psdPosFreq(:)],100,fs);
    llrH0(i) = glrtqcsig(noiseVec,psdPosFreq,[a1,a2,a3],fs);
end

signif1 = sum(llrH0(llrH0>GLRT1))/nH0data;
signif2 = sum(llrH0(llrH0>GLRT2))/nH0data;
signif3 = sum(llrH0(llrH0>GLRT3))/nH0data;