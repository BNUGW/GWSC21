addpath ../SIGNALS
addpath ../NOISE


%% Parameters for data realization
% Number of samples and sampling frequency.
nSamples = 2048;
sampFreq = 1024;
timeVec = (0:(nSamples-1))/sampFreq;

%% Supply PSD values
% This is the noise psd we will use.
noisePSD = @(f) (f>=100 & f<=300).*(f-100).*(300-f)/10000 + 1;
dataLen = nSamples/sampFreq;
kNyq = floor(nSamples/2)+1;
posFreq = (0:(kNyq-1))*(1/dataLen);
psdPosFreq = noisePSD(posFreq);

data1 = load('../DETEST/data1.txt');
data2 = load('../DETEST/data2.txt');
data3 = load('../DETEST/data3.txt');

a1=10;
a2=3;
a3=3;
A=10;

GLRT1 = glrtqcsig(data1',psdPosFreq,[a1,a2,a3],nSamples,sampFreq);
GLRT2 = glrtqcsig(data2',psdPosFreq,[a1,a2,a3],nSamples,sampFreq);
GLRT3 = glrtqcsig(data3',psdPosFreq,[a1,a2,a3],nSamples,sampFreq);

n = 1e4; n1 = 0; n2 = 0; n3 = 0;
for i =1:n
    noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);
    GLRT_i = glrtqcsig(noiseVec,psdPosFreq,[a1,a2,a3],nSamples,sampFreq);
    if GLRT_i > GLRT1
        n1 = n1 + 1;
    end
    if GLRT_i > GLRT2
        n2 = n2 + 1;
    end
    if GLRT_i > GLRT3
        n3 = n3 + 1;
    end
end
sign1 = n1/n;
sign2 = n2/n;
sign3 = n3/n;
disp(['significance of GLRT-data1 is ',num2str(sign1)]);
disp(['significance of GLRT-data2 is ',num2str(sign2)]);
disp(['significance of GLRT-data3 is ',num2str(sign3)]);
