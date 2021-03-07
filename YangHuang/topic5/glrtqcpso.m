function outResults = glrtqcpso(inParams,psoParams,nRuns)
%Regression of quadratic chirp using PSO
%O = CRCBQCPPSO(I,P,N)
%I is the input struct with the fields given below.  P is the PSO parameter
%struct. Setting P to [] will invoke default parameters (see CRCBPSO). N is
%the number of independent PSO runs. The output is returned in the struct
%O. The fields of I are:
% 'dataY': The data vector (a uniformly sampled time series).
% 'dataX': The time stamps of the data samples.
% 'dataXSq': dataX.^2
% 'dataXCb': dataX.^3
% 'rmin', 'rmax': The minimum and maximum values of the three parameters
%                 a1, a2, a3 in the candidate signal:
%                 a1*dataX+a2*dataXSq+a3*dataXCb
%The fields of O are:
% 'allRunsOutput': An N element struct array containing results from each PSO
%              run. The fields of this struct are:
%                 'fitVal': The fitness value.
%                 'qcCoefs': The coefficients [a1, a2, a3].
%                 'estSig': The estimated signal.
%                 'totalFuncEvals': The total number of fitness
%                                   evaluations.
% 'bestRun': The best run.
% 'bestFitness': best fitness from the best run.
% 'bestSig' : The signal estimated in the best run.
% 'bestQcCoefs' : [a1, a2, a3] found in the best run.

%Soumya D. Mohanty, May 2018

nSamples = length(inParams.dataX);  %通过时间序列的点数，确定采样数量

fHandle = @(x) qclrfunc(x,inParams);  %fitness function

nDim = 3;     %参数个数，或参数空间的维度
outStruct = struct('bestLocation',[],...
                   'bestFitness', [],...
                   'totalFuncEvals',[]);
                    
outResults = struct('allRunsOutput',struct('fitVal', [],...
                                           'qcCoefs',zeros(1,3),...
                                           'estSig',zeros(1,nSamples),...
                                           'totalFuncEvals',[]),...
                    'bestRun',[],...
                    'bestFitness',[],...
                    'bestSig', zeros(1,nSamples),...      %最优参数对应的信号
                    'bestQcCoefs',zeros(1,3));

%Allocate storage for outputs: results from all runs are stored
for lpruns = 1:nRuns
    outStruct(lpruns) = outStruct(1);
    outResults.allRunsOutput(lpruns) = outResults.allRunsOutput(1);
end
%Independent runs of PSO in parallel. Change 'parfor' to 'for' if the
%parallel computing toolbox is not available.
for lpruns = 1:nRuns
    %Reset random number generator for each worker
    rng(lpruns);
    outStruct(lpruns)=crcbpso(fHandle,nDim,psoParams);  
    %输入fittness function，维数，pso参数，输出最小值信息。参数的范围在之前的inParams中
    %这个函数内部的细节就无需细看了
    
    %最终给出8轮run的最小值信息
end

%Prepare output
fitVal = zeros(1,nRuns);
for lpruns = 1:nRuns   
    fitVal(lpruns) = outStruct(lpruns).bestFitness;   %每一轮的最小fitness function的值
    outResults.allRunsOutput(lpruns).fitVal = fitVal(lpruns);  %存入数据结构
    [~,qcCoefs] = fHandle(outStruct(lpruns).bestLocation);  %最佳位置的系数
    outResults.allRunsOutput(lpruns).qcCoefs = qcCoefs;  %存入数据结构
    estSig = crcbgenqcsig(inParams.dataX,1,qcCoefs);  %根据最佳系数，生成对应的信号
    [templateVec,~] = normsig4psd(estSig,inParams.sampFreq,inParams.psd,1);  %将最佳信号归一化，化为单位矢量，（矢量除以模长）
    estAmp = innerprodpsd(inParams.dataY,templateVec,inParams.sampFreq,inParams.psd);  %计算模拟数据与最佳信号的内积，即snr
    [estSig,~] = normsig4psd(estSig,inParams.sampFreq,inParams.psd,estAmp);  %用snr将最佳信号归一化
    outResults.allRunsOutput(lpruns).estSig = estSig;  %存入数据结构
    outResults.allRunsOutput(lpruns).totalFuncEvals = outStruct(lpruns).totalFuncEvals;  %存入数据结构
end
%Find the best run
[~,bestRun] = min(fitVal(:));
outResults.bestRun = bestRun;
outResults.bestFitness = outResults.allRunsOutput(bestRun).fitVal;
outResults.bestSig = outResults.allRunsOutput(bestRun).estSig;
outResults.bestQcCoefs = outResults.allRunsOutput(bestRun).qcCoefs;
end
