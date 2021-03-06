%% part of lab topic2
% signal parameters
A = 15;
B = 5;
f0 = 1e-5;
phi0 = pi/2;
%detector parameter
theta = [1/6,1/5,1/4]*pi;
phi = [1/3,1/2,2/3]*pi;
psi = theta;

%f_max at t=1
f_max = f0;
f_sampl = 5 * f0;
%sampling dt
dt = 1/f_sampl;

%time vector
t = 0:dt:365*24*3600;
%number of samples
n_sampl = length(t);

%generate signal
hp = gen_sin_sig(t,f0,A,0);
hc = gen_sin_sig(t,f0,B,phi0);

%fp,fc
[fp,fc]=det_frame_rot_fpfc(theta,phi,psi);
%strain
for i = 1:length(fp)
    s(i,:) = hp * fp(i) + hc * fc(i);
end

%plot
plot(t,s(1,:),t,s(2,:),t,s(3,:),'Marker','.','MarkerSize',24)
plot(t,hp,t,s(1,:))
 
%% LISA response
%LISA fp fc
[Fp,Fc] = Toy_LISA_FpFc(theta,phi,psi,t);
strain1 = Fp(1,:,1).*hp+Fc(1,:,1).*hc;
strain2 = Fp(1,:,2).*hp+Fc(1,:,2).*hc;
strain3 = Fp(3,:,1).*hp+Fc(3,:,1).*hc;      %different location compare to strain1
n_sampl = length(t);
kNyq = floor(n_sampl/2)+1;
% Positive Fourier frequencies
posFreq = (0:(kNyq-1))*(1/t(end));
fft_hp = fft(hp);
fft_hc = fft(hc);
fft_strain1 = fft(strain1);
fft_strain2 = fft(strain2);
fft_strain3 = fft(strain3);
fft_hp = fft_hp(1:kNyq);
fft_hc = fft_hc(1:kNyq);
fft_strain1 = fft_strain1(1:kNyq);
fft_strain2 = fft_strain2(1:kNyq);
fft_strain3 = fft_strain3(1:kNyq);
%plot
plot(posFreq,abs(fft_hp),posFreq,abs(fft_strain1),posFreq,abs(fft_strain3))

%% Doppler effect
R = 149597871e3; %1AU
w = 2*pi/(365*24*3600); %per year
c = 3e8; % light speed
%LISA centroid
x_d = R*[cos(w*t)',sin(w*t)',zeros(n_sampl,1)];
%source direction
dir_vec = @(theta,phi) [sin(theta)*cos(phi),...
           sin(theta)*sin(phi),...
           cos(theta)];

hp_doppler = gen_sin_sig(t-((dir_vec(theta(1),phi(1))*x_d')/c),f0,A,0);
hc_doppler = -gen_sin_sig(t-((dir_vec(theta(1),phi(1))*x_d')/c),f0,A,pi/2);
strain1_doppler = Fp(1,:,1).*hp_doppler+Fc(1,:,1).*hc_doppler;
 
fft_hp_doppler = fft(hp_doppler);
fft_hc_doppler = fft(hc_doppler);
fft_strain1_doppler = fft(strain1_doppler);
fft_hp_doppler = fft_hp_doppler(1:kNyq);
fft_hc_doppler = fft_hc_doppler(1:kNyq);
fft_strain1_doppler = fft_strain1_doppler(1:kNyq);

plot(posFreq,abs(fft_hp_doppler),posFreq,abs(fft_strain1_doppler))
xlim([5e-6,2e-5])
legend('h+','strain of det-1')
%plot(t,hp,t,hp_doppler)
%plot(((dir_vec(theta(1),phi(1))*x_d')/c))
