addpath ../../SIGNALS
addpath ../../NOISE
addpath ../../DETEST
addpath ../../../SDMBIGDAT19/CODES

%% 定义基本参数（采样率，采样总量）
nSamples = 512;  %采样点数
sampFreq = 512; % 采样率
timeVec = (0:(nSamples-1))/sampFreq;  %每一个采样点对应的时间点序列


%% 预处理
dataLen = nSamples/sampFreq;  %总数据时长
kNyq = floor(nSamples/2)+1;  %数据允许的最大频率
posFreq = (0:(kNyq-1))*(1/dataLen);  %正频率


%% 模拟数据
%噪声
psdFunc = @(f) (f>=50 & f<=100).*(f-50).*(100-f)/625 + 1;
psdPosFreq = psdFunc(posFreq);  %正频psd
noiseVec = statgaussnoisegen(nSamples,[posFreq(:),psdPosFreq(:)],100,sampFreq);    %噪声序列

%信号
snr = 10;
a1 = 3;
a2 = 2;
a3 = 5;
sigVec = crcbgenqcsig(timeVec,snr,[a1,a2,a3]);   %信号数据
[sigVec,~]=normsig4psd(sigVec,sampFreq,psdPosFreq,snr);  %将信号按照指定的snr进行归一化

%组合成最终的模拟数据
dataY = noiseVec + sigVec;


%% 通过pso，在指定的参数空间中搜索最小fitness（并行多次）
%给fitness function传入的参数
inParams = struct( 'rmin',         [1,1,1],        ...  %三个参数a1，a2，a3的最小值组成的序列
                    'rmax',         [60,20,10],    ...
                    'dataX',        timeVec,        ...
                    'dataXSq',      timeVec.^2,     ...
                    'dataXCb',      timeVec.^3,     ...
                    'sampFreq',     sampFreq,       ...  %采样率
                    'psd',   psdPosFreq,     ...  %正频psd
                    'dataY',        dataY         ...  %模拟数据
                   );
               
%返回总共8次的所有结果，并选择出了最优结果可供提取
finalResult = glrtqcpso(inParams,struct('maxSteps',2000), 5);  

%% 做图
figure
hold on
plot(timeVec,dataY, '.','MarkerSize',12, 'Color',[78, 110, 242]/255  )
plot(timeVec,sigVec,'LineWidth',3, 'Color',[221, 80, 68]/255)
plot(timeVec,finalResult.bestSig,'LineWidth',3, 'Color',[38, 37, 36]/255)
legend('data','signal','BestSignal')
xlabel('time (s)')
hold off

disp(finalResult.bestQcCoefs)