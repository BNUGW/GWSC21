clear;clc;
testData = load('../../NOISE/testData.txt');
timeVec = testData(:,1);
dataVec = testData(:,2);

sampFreq = 1/(timeVec(2)-timeVec(1)) ;
[pxx,f]=pwelch(dataVec, 256,[],[],sampFreq);
figure;
plot(f,pxx);
xlabel('Frequency (Hz)');
ylabel('PSD');

dataWhitened = whiten(dataVec,[f,pxx],10, sampFreq );


figure;
hold on
plot(timeVec,dataVec)
plot(timeVec,dataWhitened )
hold off


