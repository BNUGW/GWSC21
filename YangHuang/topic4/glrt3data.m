clear;clc;
d1Vec = load('../../DETEST/data1.txt');
d2Vec = load('../../DETEST/data2.txt');
d3Vec = load('../../DETEST/data3.txt');

sampleFreq = 1024;

sigParams = struct('a1', 10, ...
                   'a2', 3, ...
                   'a3', 3);
N = length(d1Vec);
timeVec = (0:N-1)*(1/sampleFreq);

noisePsd = @(f)(f>=100&f<=300).*(f-100).*(300-f)/10000+1;
posFreq = (0: floor(N/2)) * (sampleFreq/N);
psdPosFreq = noisePsd(posFreq);

g1 = glrtqcsigIn(d1Vec,timeVec, psdPosFreq, sigParams,sampleFreq)

function llr = glrtqcsigIn(dataVec,timeVec, psdPosFreq, sigParams,sampFreq)

addpath ../../../SDMBIGDAT19/CODES
addpath ../../DETEST

A = 10;
a1 = sigParams.a1;
a2 = sigParams.a2;
a3 = sigParams.a3;

sigVec = crcbgenqcsig(timeVec,A,[a1,a2,a3]);
%We do not need the normalization factor, just the  template vector
[templateVec,~] = normsig4psd(sigVec,sampFreq,psdPosFreq,1);
% Calculate inner product of data with template
llr = innerprodpsd(dataVec,templateVec,sampFreq,psdPosFreq);
%GLRT is its square
llr = llr^2;
end
