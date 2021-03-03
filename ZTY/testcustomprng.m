%% Topic 3 lab1 
N = 10000;
U = customrand(-2,1,1,N);
N = customrandn(1.5,2.0,1,N);
%plot histogram
subplot(1,2,1)
histogram(U,'normalization','pdf')
hold on
plot(-2:0.1:1,1/3*ones(1,31))
legend('samples','pdf')
hold off
subplot(1,2,2)
histogram(N,'normalization','pdf')
hold on
x = -10:0.05:10;
plot(x,normpdf(x,1.5,2.0))
legend('samples','pdf')
hold off

%% Topic 3 lab2
load('../NOISE/testData.txt');
n_sampl = length(testData(:,1));
t = testData(:,1);
data_tot = testData(:,2);
f_sampl = (n_sampl - 1)/t(end);
%0-5s is pure noise
noise = data_tot(1:floor(5*f_sampl+1));
[psd,f]=pwelch(noise, 256,[],[],f_sampl);
figure;
plot(f,psd);
xlabel('Frequency (Hz)');
ylabel('PSD');

fltrOrdr = 500;
b = fir2(fltrOrdr,f/(f_sampl/2),1./sqrt(psd));
whittened_data = (1/sqrt(f_sampl))*fftfilt(b,data_tot);
plot(t,data_tot,t,whittened_data)

kNyq = floor(n_sampl/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/t(end));
fft_data_tot = fft(data_tot);
fft_data_tot = fft_data_tot(1:kNyq);
fft_whittened_data = fft(whittened_data);
fft_whittened_data = fft_whittened_data(1:kNyq);
plot(posFreq,abs(fft_data_tot),posFreq,abs(fft_whittened_data))
% Plot a spectrogram 
%----------------
winLen = 0.2;%sec
ovrlp = 0.1;%sec
%Convert to integer number of samples 
winLenSmpls = floor(winLen*f_sampl);
ovrlpSmpls = floor(ovrlp*f_sampl);
[S,F,T]=spectrogram(data_tot,winLenSmpls,ovrlpSmpls,[],f_sampl);
[S1,F1,T1]=spectrogram(whittened_data,winLenSmpls,ovrlpSmpls,[],f_sampl);
subplot(1,2,1)
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('original data')
colorbar

subplot(1,2,2)
imagesc(T1,F1,abs(S1)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
title('whittened data')
colorbar
