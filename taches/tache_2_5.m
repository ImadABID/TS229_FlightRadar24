%% Init
clc;
clear all;
close all;

addpath("../src/PHY");

%{
%% par
sig_len = 256*1000;
sigma = 1;
sig = normrnd(0,sigma, [1, sig_len]);

%% traitement
[dsp_sig, f] = Mon_Welch_perso(sig, 256, 1000);

figure
plot(f, dsp_sig)
%}

%% Params

Fe = 20 * 1e6; %Hz
Fse = 20;
Fs = Fe/Fse;

Ts = 20;

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

figure
plot(f, dsp_sig .* Fe)

%% theorique
g = xcorr(P, Nfft) + 0.25;
dsp_theo = 1/Ts * abs(fftshift(fft(P, Nfft))).^2;

%dsp_theo = 0.5 * abs(fftshift(fft(P, Nfft))).^2;

hold on;
plot(f, dsp_theo)
