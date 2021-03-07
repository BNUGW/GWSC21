clear;clc;
ligoPsd = load('../../NOISE/iLIGOSensitivity.txt','-ascii');

addpath '../NOISE'
f_sampl = 10000;

iLIGO_mod = zeros(size(ligoPsd));
iLIGO_trunc = [];
for i = 1:length(ligoPsd(:,1))
    iLIGO_mod(i,1) = ligoPsd(i,1);
    if (ligoPsd(i,1) < 50 & ligoPsd(i+1,1) > 50)
        iLIGO_mod(1:i,2) = ligoPsd(i,2)*ones(i,1);
    
    elseif (ligoPsd(i,1) < 700 & ligoPsd(i+1,1) > 700)
        iLIGO_mod(i,2) = ligoPsd(i,2);
        iLIGO_mod(i+1:end,1) = ligoPsd(i+1:end,1);
        iLIGO_mod(i+1:end,2) = ligoPsd(i,2)*ones(length(ligoPsd(:,1)) - i,1);
        break
    else
        iLIGO_mod(i,2) = ligoPsd(i,2);
    end
end
for i = 1:length(iLIGO_mod(:,1))
    if (ligoPsd(i,1) < f_sampl/2 & ligoPsd(i+1,1) > f_sampl/2)
        tmp1 = ligoPsd(i+1:end,:);
        iLIGO_mod(i+1,:) = [f_sampl/2, (ligoPsd(i,2) + ligoPsd(i+1,2))/2];
        iLIGO_trunc = iLIGO_mod(1:i+1,:);
        iLIGO_mod = [iLIGO_mod(1:i+1,:);tmp1];
        break
    end
end
tmp = [[0,iLIGO_mod(1,2)];iLIGO_mod];
iLIGO_mod = tmp;

tmp = [[0,iLIGO_mod(1,2)];iLIGO_trunc];
iLIGO_trunc = tmp;
tmp = [[0,ligoPsd(1,2)];ligoPsd];
ligoPsd = tmp;


% 根据ligo的psd生成噪声
fltrOrdr = 100;
n_sampl = 5*f_sampl;
outNoise = statgaussnoisegen(n_sampl,iLIGO_trunc,fltrOrdr,f_sampl);

%根据生成的噪声反推psd
[pxx,f]=pwelch(outNoise, 256,[],[],f_sampl);

%做图
figure;
loglog(f,pxx,ligoPsd(:,1),ligoPsd(:,2));
legend('estimated noise psd','iLIGO psd')
xlabel('Frequency (Hz)');
ylabel('PSD');


figure;
timeVec = (0:(n_sampl-1))/f_sampl;
plot(timeVec,outNoise);




% 
% 
% 
% 
% 
% 
% 
% 
% %% Generate noise realization
% fVec = ligoPsd(:,1);
% psdVec = ligoPsd(:,2).^2;
% sampFreq = 2*fVec(end);
% [N,~] = size(fVec);
% nSamples = N*2;
% 
% fltrOrdr = 500;
% outNoise = statgaussnoisegen(nSamples,[fVec,psdVec],fltrOrdr,sampFreq);
% 
% figure;
% plot(timeVec,outNoise);
% 
% %%
% % Estimate the PSD
% % (Pwelch plots in dB (= 10*log10(x)); plot on a linear scale)
% [pxx,f]=pwelch(outNoise, 256,[],[],sampFreq);
% figure;
% plot(f,pxx);
% xlabel('Frequency (Hz)');
% ylabel('PSD');