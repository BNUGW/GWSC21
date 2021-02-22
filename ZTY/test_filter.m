%% lab5:
n_sampl = 2048;
f_sampl = 1024;
%f_max of sin signal is f_sampl/2 = 512 Hz

%parameters
A1 = 10;    f1 = 100;   phi1 = 0;
A2 = 5;     f2 = 200;   phi2 = pi/6;
A3 = 2.5;   f3 = 300;   phi3 = pi/4;
%generate signals
t = 0:1/f_sampl:(2 - 1/f_sampl);
sig1 = gen_sin_sig(t,f1,A1,phi1);
sig2 = gen_sin_sig(t,f2,A2,phi2);
sig3 = gen_sin_sig(t,f3,A3,phi3);

sig = sig1 + sig2 + sig3;

% Design filter
filtOrdr = 100;
lowpass = fir1(filtOrdr,150/(f_sampl/2));
bandpass = fir1(filtOrdr,[150,250]/(f_sampl/2));
highpass = fir1(filtOrdr,250/(f_sampl/2),'high');
%for test the filter
%freqz(bandpass,1)
% Apply filter
lowpass_sig = fftfilt(lowpass,sig);
bandpass_sig = fftfilt(bandpass,sig);
highpass_sig = fftfilt(highpass,sig);

%time duration
T = 2;
%DFT sample corresponding to Nyquist frequency
kNyq = floor(n_sampl/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/T);
% FFT of signal
fft_sig = fft(sig); 
fft_lowpass_sig = fft(lowpass_sig);
fft_bandpass_sig = fft(bandpass_sig);
fft_highpass_sig = fft(highpass_sig);
% Discard negative frequencies
fft_sig = fft_sig(1:kNyq);
fft_lowpass_sig = fft_lowpass_sig(1:kNyq);
fft_bandpass_sig = fft_bandpass_sig(1:kNyq);
fft_highpass_sig = fft_highpass_sig(1:kNyq);


%Plot periodogram
%plot(posFreq,abs(fft_sig));
subplot(2,3,1)
plot(posFreq,abs(fft_sig))
subplot(2,3,4)
plot(posFreq,abs(fft_lowpass_sig))
subplot(2,3,2)
plot(posFreq,abs(fft_sig))
subplot(2,3,5)
plot(posFreq,abs(fft_bandpass_sig))
subplot(2,3,3)
plot(posFreq,abs(fft_sig))
subplot(2,3,6)
plot(posFreq,abs(fft_highpass_sig))