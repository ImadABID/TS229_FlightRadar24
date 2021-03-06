%% Init
clc;
clear all;
close all;

addpath("../PHY/");

%% Params

Fe = 20 * 1e6; %Hz
Fse = 20;
Fs = Fe/Fse;

Ts = Fse;

Nfft = 256;

% p def
middle = floor(Fse/2);
P = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];

%% input
packet_size = 10000;
bk = randi([0 1], 1, packet_size);
len_bk = size(bk); len_bk = len_bk(1,2);


%% PPM Modulation
sl = modulatePPM(bk, Fse);
[dsp_sig, f] = Mon_Welch(sl, Nfft, Fe);
dsp_sig = Fe .* dsp_sig;

figure
plot(f, dsp_sig)

%% theorique

R_l_tilde = 1/Ts .* xcorr(P);

TF_R_l_tilde = fft(R_l_tilde, Nfft);
TF_R_l_tilde(1, 1) = TF_R_l_tilde(1, 1) + 0.25*Nfft;
dsp_theo = abs(fftshift(TF_R_l_tilde));

hold on;
plot(f, dsp_theo)

xlabel('f');
ylabel('DSP');
legend('DSP expérimentale', 'DSP théorique');