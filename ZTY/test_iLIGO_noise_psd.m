%% Topic3 lab3
addpath '../NOISE'
iLIGO = load('../NOISE/iLIGOSensitivity.txt');
f_sampl = 10000;
iLIGO_mod = zeros(size(iLIGO));
iLIGO_trunc = [];
for i = 1:length(iLIGO(:,1))
    iLIGO_mod(i,1) = iLIGO(i,1);
    if (iLIGO(i,1) < 50 & iLIGO(i+1,1) > 50)
        iLIGO_mod(1:i,2) = iLIGO(i,2)*ones(i,1);
    
    elseif (iLIGO(i,1) < 700 & iLIGO(i+1,1) > 700)
        iLIGO_mod(i,2) = iLIGO(i,2);
        iLIGO_mod(i+1:end,1) = iLIGO(i+1:end,1);
        iLIGO_mod(i+1:end,2) = iLIGO(i,2)*ones(length(iLIGO(:,1)) - i,1);
        break
    else
        iLIGO_mod(i,2) = iLIGO(i,2);
    end
end
for i = 1:length(iLIGO_mod(:,1))
    if (iLIGO(i,1) < f_sampl/2 & iLIGO(i+1,1) > f_sampl/2)
        tmp1 = iLIGO(i+1:end,:);
        iLIGO_mod(i+1,:) = [f_sampl/2, (iLIGO(i,2) + iLIGO(i+1,2))/2];
        iLIGO_trunc = iLIGO_mod(1:i+1,:);
        iLIGO_mod = [iLIGO_mod(1:i+1,:);tmp1];
        break
    end
end
tmp = [[0,iLIGO_mod(1,2)];iLIGO_mod];
iLIGO_mod = tmp;

tmp = [[0,iLIGO_mod(1,2)];iLIGO_trunc];
iLIGO_trunc = tmp;
tmp = [[0,iLIGO(1,2)];iLIGO];
iLIGO = tmp;

fltrOrdr = 100;

n_sampl = 5*f_sampl;

outNoise = statgaussnoisegen(n_sampl,iLIGO_trunc,fltrOrdr,f_sampl);

% Estimate the PSD
% (Pwelch plots in dB (= 10*log10(x)); )
[pxx,f]=pwelch(outNoise, 256,[],[],f_sampl);
figure;
loglog(f,pxx,iLIGO(:,1),iLIGO(:,2));
legend('estimated noise psd','iLIGO psd')
xlabel('Frequency (Hz)');
ylabel('PSD');
% Plot the colored noise realization
figure;
timeVec = (0:(n_sampl-1))/f_sampl;
plot(timeVec,outNoise);