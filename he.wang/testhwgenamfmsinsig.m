%% Plot the AM-FM sinusoid signal
% Signal parameters
A = 10;
f0 = 60;
f1 = 10;
f2 = 5;
b = 20;
% Instantaneous frequency after 1 sec is 
MaxFreq = f0;
samplFreq = 5*MaxFreq;
HalfFreq = 1/2 * MaxFreq;
samplIntrvl = 1/samplFreq;

% Time samples
timeVec = 0:samplIntrvl:1.0;
% timeVec = (0:(sampFreq*5-1))/sampFreq;
% Number of samples
nSamples = length(timeVec);

% Generate the signal
sigVec = hwgenamfmsinsig(timeVec,A,f0,f1,f2,b);

%Plot the signal 
figure;
plot(timeVec,sigVec,'Marker','.','MarkerSize',24);
hold;
plot(0:(1/HalfFreq):1.0,hwgenamfmsinsig(0:(1/HalfFreq):1.0,A,f0,f1,f2,b),'Marker','o','MarkerSize',14);

%% Plot the periodogram
%--------------
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signal
fftSig = fft(sigVec);
% Discard negative frequencies
fftSig = fftSig(1:kNyq);

%Plot periodogram
figure;
plot(posFreq,abs(fftSig));

%% Plot a spectrogram
%----------------
sampFreq = 1024;
nSamples = 2048/2;
timeVec = (0:(nSamples-1))/sampFreq;

% Generate signal
sigVec = hwgenamfmsinsig(timeVec,A,f0,f1,f2,b);

winLen = 1/128; % perc
ovrlp = winLen/2; % perc
%Convert to integer number of samples 
winLenSmpls = floor(winLen*nSamples);
ovrlpSmpls = floor(ovrlp*nSamples);
[S,F,T]=spectrogram(sigVec,winLenSmpls,ovrlpSmpls,[],sampFreq);
% [S,F,T]=spectrogram(sigVec, 256,250,[],sampFreq);

% Plot
figure;
subplot(2,1,1);
plot(timeVec,sigVec);title('l6lab - the AM-FM sinusoid signal');

subplot(2,1,2);
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');
saveas(gcf,'l6lab_hwgenamfmsinsig','png')