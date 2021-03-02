%% Task 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate a signal containing the sum of three sinusoids with the 
% following parameters.

% Signal parameters
A1 = 10;
A2 = 5;
A3 = 2.5;
f1 = 100;
f2 = 200;
f3 = 300;
phi1 = 0;
phi2 = pi/6;
phi3 = pi/4;

% Instantaneous frequency after 1 sec is 
sampFreq = 1024;

% Number of samples
nSamples = 2048;

% Time samples
timeVec = (0:(nSamples-1))/sampFreq;

% Generate the signal
sigVec1 = hwgensinsig(timeVec,A1,f1,phi1);
sigVec2 = hwgensinsig(timeVec,A2,f2,phi2);
sigVec3 = hwgensinsig(timeVec,A3,f3,phi3);
sigVec = sigVec1 + sigVec2 + sigVec3;

% The maximum frequency
maxFreq = sampFreq/2;
disp(['The maximum frequency of the discrete time sinusoid is ', num2str(maxFreq)]);

%% Task 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use Matlab's `fir1` function to design 3 different filters such that 
% filter #i alows only sigVeci to pass through.

% Remove frequencies such that sigVec1/sigVec2/sigVec3 can pass through
% Design low/band/high pass filters
filt0rdr = 30;
b1 = fir1( filt0rdr, (f2+f1)/2/(sampFreq/2), 'low' );
b2 = fir1( filt0rdr, [(f2+f1)/2/(sampFreq/2),(f3+f2)/2/(sampFreq/2)], 'bandpass' );
b3 = fir1( filt0rdr, (f3+f2)/2/(sampFreq/2), 'high' );
% Apply filters
filtSig1 = fftfilt(b1, sigVec);
filtSig2 = fftfilt(b2, sigVec);
filtSig3 = fftfilt(b3, sigVec);

% % Plots
% figure;
% plot(timeVec,filtSig1);
% figure;
% plot(timeVec,filtSig2);
% figure;
% plot(timeVec,filtSig3);

%% Task 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the correspond periodograms of the input and the filter output.

%Plot the periodograms
%--------------
%Length of data 
dataLen = timeVec(end)-timeVec(1);
%DFT sample corresponding to Nyquist frequency
kNyq = floor(nSamples/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/dataLen);
% FFT of signals
fftSig1 = fft(sigVec1);
fftSig2 = fft(sigVec2);
fftSig3 = fft(sigVec3);
% Discard negative frequencies
fftSig1 = fftSig1(1:kNyq);
fftSig2 = fftSig2(1:kNyq);
fftSig3 = fftSig3(1:kNyq);

figure;
subplot(3,3,[1,2,3]);
plot(timeVec,sigVec);
title('sigVec');xlabel('Time (sec)');

subplot(3,3,4);
plot(timeVec,sigVec1);
title('sigVec1');xlabel('Time (sec)');

subplot(3,3,5);
plot(timeVec,sigVec2);
title('sigVec2');xlabel('Time (sec)');

subplot(3,3,6);
plot(timeVec,sigVec3);
title('sigVec3');xlabel('Time (sec)');

%Plot periodograms
subplot(3,3,7);
plot(posFreq,abs(fftSig1));
xlabel('Frequency (Hz)');

subplot(3,3,8);
plot(posFreq,abs(fftSig2));
xlabel('Frequency (Hz)');

subplot(3,3,9);
plot(posFreq,abs(fftSig3));
xlabel('Frequency (Hz)');
