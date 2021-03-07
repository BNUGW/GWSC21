sampFreq = 1024;
nSamples = 2048;
t = (0:(nSamples-1))/sampFreq;

s1 = 10*sin( 2 * pi * 100 * t) 
s2 = 5 * sin( 2 * pi * 200 * t + pi/6 ) 
s3 = 2.5 * sin( 2 * pi * 300 * t + pi/4 ) ;
s = s1+s2+s3 ;


%Length of data 
dataLen = t(end)-t(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);


%% allows only 𝑠1 to pass through
filt0rdr = 30;
b = fir1( filt0rdr, 150/(sampFreq/2) ) ;
filtSig = fftfilt(b, s);

%plots
figure(11);
hold on;
plot(t,s);
plot(t,filtSig);

% plot the periodogram  %
% FFT of signal
fftSig = fft(s);
fftSig = fftSig(1:kNyq);

% FFT of filtered signal
fftFiltSig = fft(filtSig);
fftFitSig = fftFiltSig(1:kNyq);

%Plot periodogram
figure(12);
subplot(2,1,1);
plot(posFreq,abs(fftSig));
subplot(2,1,2);
plot(posFreq,abs(fftFitSig));





%% allows only 𝑠2 to pass through
filt0rdr = 30;
b = fir1( filt0rdr, [150/(sampFreq/2), 250/(sampFreq/2)] ) ;
filtSig = fftfilt(b, s);

%plots
figure(21);
hold on;
plot(t,s);
plot(t,filtSig);

% plot the periodogram  %
% FFT of signal
fftSig = fft(s);
fftSig = fftSig(1:kNyq);

% FFT of filtered signal
fftFiltSig = fft(filtSig);
fftFitSig = fftFiltSig(1:kNyq);

%Plot periodogram
figure(22);
subplot(2,1,1);
plot(posFreq,abs(fftSig));
subplot(2,1,2);
plot(posFreq,abs(fftFitSig));

%% allows only 𝑠3 to pass through
filt0rdr = 30;
b = fir1( filt0rdr, 250/(sampFreq/2), 'high' ) ;
filtSig = fftfilt(b, s);

%plots
figure(31);
hold on;
plot(t,s);
plot(t,filtSig);

% plot the periodogram  %
% FFT of signal
fftSig = fft(s);
fftSig = fftSig(1:kNyq);

% FFT of filtered signal
fftFiltSig = fft(filtSig);
fftFitSig = fftFiltSig(1:kNyq);

%Plot periodogram
figure(32);
subplot(2,1,1);
plot(posFreq,abs(fftSig));
subplot(2,1,2);
plot(posFreq,abs(fftFitSig));