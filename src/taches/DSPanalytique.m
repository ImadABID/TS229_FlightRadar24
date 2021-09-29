%% Init
clc;
clear all;
close all;



%% Params

Fe = 20 * 1e6; %Hz
Fse = 20;
Fs = Fe/Fse;
Ts = 1e-6;
Nfft=256;
f = [0:Nfft * Fse-1];
% p def
middle = floor(Fse/2);

P = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];

autocorrelation = xcorr(P,Nfft * Fse);
g = autocorrelation + 0.25 * Ts;
G = abs(fftshift(fft(g, Nfft * Fse))).^2;


plot(f, G/Ts)