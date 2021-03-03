function [fitVal,varargout] = glrtqcsig4pso(xVec,params)
%Fitness function for quadratic chirp regression
%F = GLRTQCSIG4PSO(X,P)
%Compute the fitness function (log-likelihood ratio for colored noise maximized
%over the amplitude parameter) for data containing the quadratic chirp signal. X.
%The fitness values are returned in F. X is standardized, that is 0<=X(i,j)<=1. 
%The fields P.rmin and P.rmax  are used to convert X(i,j) internally 
%before computing the fitness:
%X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
%The fields P.dataY and P.dataX are used to transport the data and its
%time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
%squared and cubed respectively.
%An extra field P.psdPosFreq is to supply the PSD for colored noise.
%An extra filed P.sampFreq is the sampling rate.
%
%[F,R] = GLRTQCSIG4PSO(X,P)
%returns the quadratic chirp coefficients corresponding to the rows of X in R. 
%Coverts standardized to real (unstandardized) coordinates, i.e., the
%parameters a1, a2, and a3.
%
%[F,R,S] = GLRTQCSIG4PSO(X,P)
%Returns the quadratic chirp signals corresponding to the rows of X in S. 
%Coverts the real coordinates to QC signal time series.

%Soumya D. Mohanty
%June, 2011
%April 2012: Modified to switch between standardized and real coordinates.

%Shihan Weerathunga
%April 2012: Modified to add the function rastrigin.

%Soumya D. Mohanty
%May 2018: Adapted from rastrigin function.

%Soumya D. Mohanty
%Adapted from QUADCHIRPFITFUNC
%==========================================================================

%rows: points
%columns: coordinates of a point
[nVecs,~]=size(xVec);

%storage for fitness values
fitVal = zeros(nVecs,1);

%Check for out of bound coordinates and flag them
validPts = crcbchkstdsrchrng(xVec);
%Set fitness for invalid points to infty
fitVal(~validPts)=inf;
xVec(validPts,:) = s2rv(xVec(validPts,:),params);

for lpc = 1:nVecs
    if validPts(lpc)
    % Only the body of this block should be replaced for different fitness
    % functions
        x = xVec(lpc,:);
        fitVal(lpc) = ssrqc(x, params);
    end
end

%Return real coordinates if requested
if nargout > 1
    varargout{1}=xVec;
end

%Sum of squared residuals after maximizing over amplitude parameter
function ssrVal = ssrqc(x,params)
%Generate normalized quadratic chirp
%More efficient if the signal is generated inside this function for speed 
%(calling crcbgenqcsig.m would be slow because dataX.^2 and dataX.^3 will 
%be recomputed in every call but they need to be computed only once).
phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);
% qc = qc/norm(qc);
% 
% My version (Bad)
% qc = qc/innerprodpsd(qc,qc,params.sampFreq,params.psdPosFreq);
% 
% Pref. version
[qc,~]=normsig4psd(qc,params.sampFreq,params.psdPosFreq,1);
%We do not need the normalization factor, just the need template vector


%Compute fitness (Calculate inner product of data with template qc£©
% ssrVal = -(params.dataY*qc')^2;
% 
% My version
% ssrVal = - innerprodpsd(params.dataY,qc,params.sampFreq,params.psdPosFreq)^2;
% 
% Prof. version
inPrd = innerprodpsd(params.dataY,qc,params.sampFreq,params.psdPosFreq);
ssrVal = -(inPrd)^2;
