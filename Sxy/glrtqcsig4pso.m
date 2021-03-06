function [fitVal,varargout] = glrtqcsig4pso(xVec,params)
%Fitness function for quadratic chirp regression .  %5 sampFreq,psdVec,snr
%F = CRCBQCFITFUNC(X,P)
%Compute the fitness function (sum of squared residuals function after
%maximimzation over the amplitude parameter) for data containing the
%quadratic chirp signal. X.  The fitness values are returned in F. X is
%standardized, that is 0<=X(i,j)<=1. The fields P.rmin and P.rmax  are used
%to convert X(i,j) internally before computing the fitness:
%X(:,j) -> X(:,j)*(rmax(j)-rmin(j))+rmin(j).
%The fields P.dataY and P.dataX are used to transport the data and its
%time stamps. The fields P.dataXSq and P.dataXCb contain the timestamps
%squared and cubed respectively.
%
%[F,R] = CRCBQCFITFUNC(X,P)
%returns the quadratic chirp coefficients corresponding to the rows of X in R. 
%
%[F,R,S] = CRCBQCFITFUNC(X,P)
%Returns the quadratic chirp signals corresponding to the rows of X in S.

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

%6
%sampFreq=params.sampFreq;
%psdVec=params.psdVec;
%snr=params.snr;

%disp(888);


%disp(params);
%disp(sampFreq);
%disp(snr);


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

phaseVec = x(1)*params.dataX + x(2)*params.dataXSq + x(3)*params.dataXCb;
qc = sin(2*pi*phaseVec);


%sampFreq,psdVec,snr
[qc,~] = normsig4psd(qc,params.sampFreq,params.psdVec,params.snr);
%qc = qc/normsig4psd(qc,512,params.psdVec,10);

%Compute fitness
%ssrVal = -(params.dataY*qc')^2;

ssrVal=-(innerprodpsd(params.dataY,qc,params.sampFreq,params.psdVec))^2;

