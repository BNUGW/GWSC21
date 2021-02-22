%% plot signal  (lab3)
% parameters
snr = 10;
t0 = 0.5;
sigma = 1;
f0 = 8;
phi0 = pi/2;

%f_max at t=1
f_max = f0;
f_sampl = 5 * f0;
%sampling dt
dt = 1/f_sampl;

%time vector
t = 0:dt:1.0;
%number of samples
n_sampl = length(t);

%generate S-G signal
sig = gen_Sine_Gaussian_Sig(t,snr,t0,sigma,f0,phi0);
%plot
plot(t,sig,'Marker','.','MarkerSize',24)

%% identify phase function (lab4)
%phi(t) = f0*t
%dphi(t)/dt = f0 ---const
%under 1/2 Nyquist frequency
f_sampl1 = f0/2;
t1 = 0:1/f_sampl1:1;
%under 5 Nyquist frequency
f_sampl2 = 5 * f0;
t2 = 0:1/f_sampl2:1;

sig1 = gen_Sine_Gaussian_Sig(t1,snr,t0,sigma,f0,phi0);
sig2 = gen_Sine_Gaussian_Sig(t2,snr,t0,sigma,f0,phi0);
plot(t1,sig1,t2,sig2,'Marker','.','MarkerSize',24)
legend('1/2 Nyquist frequency','5 Nyquist frequency')
xlabel('Time (sec)')
ylabel('sampled signal')
%% Plot a spectrogram (lab6)
%----------------
winLen = 0.25;%sec
ovrlp = 0.05;%sec
%Convert to integer number of samples 
winLenSmpls = floor(winLen*f_sampl);
ovrlpSmpls = floor(ovrlp*f_sampl);
[S,F,T]=spectrogram(sig,winLenSmpls,ovrlpSmpls,[],f_sampl);
figure;
imagesc(T,F,abs(S)); axis xy;
xlabel('Time (sec)');
ylabel('Frequency (Hz)');