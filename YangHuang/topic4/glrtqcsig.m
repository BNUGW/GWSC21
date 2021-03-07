function llr = glrtqcsig(dataVec,timeVec, psdPosFreq, sigParams,sampFreq)

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
