%% Init
clc;
clear all;
close all;

addpath("../PHY/");

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;

% p def
middle = floor(Fse/2);
P = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];


figure()
nbr_fig = 6;

%% input
bk = [1, 0, 0, 1, 0];
%bk = repmat(bk, 1, 100);
len_bk = size(bk); len_bk = len_bk(1,2);

subplot(nbr_fig, 1, 1)
plot((0:Fse:(len_bk-1)*Fse), bk, "*")
xlim([-Fse, len_bk*Fse])
ylabel("b_k")

%% PPM Modulation
sl = modulatePPM(bk, Fse);

subplot(nbr_fig, 1, 2)
plot((0:1:len_bk*Fse-1), sl)
xlim([-Fse, Fse*len_bk])
ylabel("s_l")

%% Canal
nl = zeros(1, Fse*len_bk);
%nl = normrnd(0, 0.2, [1 Fse*len_bk]);
yl = sl + nl;

subplot(nbr_fig, 1, 3)
plot((0:1:len_bk*Fse-1),yl)
xlim([-Fse, Fse*len_bk])
ylabel("y_l")

delta_f = -1000; %Hz
yl_decf = yl .* exp(-1j*2*pi*delta_f*1/Fe*(0:1:len_bk*Fse-1));

%% Filtre adapte
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];

rl = conv(yl_decf, p_ada);

subplot(nbr_fig, 1, 4)
plot(abs(rl))
ylabel("r_l")

%% Echantionnage
rm = zeros(1, len_bk);
for i=1:1:len_bk
    rm(1, i) = rl(1, Fse*i);
end

subplot(nbr_fig, 1, 5)
plot((Fse:Fse:len_bk*Fse), rm, "*")
xlim([0, Fse*(len_bk+1)])
ylabel("r_m")

%% Decision
b_estim = zeros(1, len_bk);
for i=1:1:len_bk
    if(rm(1, i)>0)
        b_estim(1, i) = 0;
    else
        b_estim(1, i) = 1;
    end
end

subplot(nbr_fig, 1, 6)
plot((Fse:Fse:len_bk*Fse), b_estim, "*")
xlim([0, Fse*(len_bk+1)])
ylabel("b_estime")

figure,

subplot(2,1, 1)
plot(fftshift(abs(fft(yl))))

subplot(2,1, 2)
plot(fftshift(abs(fft(yl_decf))))