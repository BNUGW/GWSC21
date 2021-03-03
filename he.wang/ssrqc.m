function ssrVal = ssrqc(x,params)
%Generate normalized quadratic chirp
%More efficient if the signal is generated inside this function for speed 
%(calling crcbgenqcsig.m would be slow because dataX.^2 and dataX.^3 will 
%be recomputed in every call but they need to be computed only once).
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);
% qc = qc/norm(qc);
qc = qc/innerprodpsd(qc,qc,params.sampFreq,params.psdPosFreq);
%We do not need the normalization factor, just the need template vector


%Compute fitness (Calculate inner product of data with template qc£©
% ssrVal = -(params.dataY*qc')^2;
ssrVal = - innerprodpsd(params.dataY,qc,params.sampFreq,params.psdPosFreq)^2;
