%% The sinusoidal signal for different F_+ and F_x

% Signal parameters
A = 10;
B = 20;
f0 = 50;
phi0 = pi;

% Sampling rate
sampFreq = 1024/2;
% Number of samples
nSamples = 2048/2;
% Time samples
timeVec = (0:(nSamples-1))/sampFreq;

% Generate signal
hp = hwgensinsig(timeVec,A,f0,0);
hc = hwgensinsig(timeVec,B,f0,phi0);

%% For different F_+ and F_x caculation
%Polar
theta = pi /2; % 0~pi;
%Azimuthal
phi = 2*pi /3; % 0~2*pi;
%Roation
psi = 2*pi /3; % 0~2*pi;

%Generate function of antenna patterns 
% Based on eq.(3) and eq.(4) of arXiv:gr-qc/0008066
fPlus = formulafp(phi,theta)*cos(2*psi) - formulafc(phi,theta)*sin(2*psi);
fCross = -formulafp(phi,theta)*sin(2*psi) - formulafc(phi,theta)*cos(2*psi);

% Generate signal (detector response not considerd)
sigVec = fPlus * hp + fCross * hc;

% Plot the signal
figure;
plot(timeVec,sigVec);