%% Init
clc;
clear all;
close all;

addpath("../src/PHY");

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;

% p def
middle = floor(Fse/2);
P = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];


figure()
nbr_fig = 3;

%% input
bk = [1, 0, 0, 1, 0];
len_bk = size(bk); len_bk = len_bk(1,2);

% subplot(nbr_fig, 1, 1)
% plot((0:Fse:(len_bk-1)*Fse), bk, "*")
% xlim([-Fse, len_bk*Fse])
% ylabel("b_k")

%% PPM Modulation
sl = modulatePPM(bk, Fse);

% subplot(nbr_fig, 1, 2)
% plot((0:1:len_bk*Fse-1), sl)
% xlim([-Fse, Fse*len_bk])
% ylabel("s_l")

%% Canal
nl = zeros(1, Fse*len_bk);
yl = sl + nl;

% subplot(nbr_fig, 1, 3)
% plot((0:1:len_bk*Fse-1),yl)
% xlim([-Fse, Fse*len_bk])
% ylabel("y_l")

%% Filtre adapte
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];

rl = conv(yl, p_ada);

% subplot(nbr_fig, 1, 4)
% plot(rl)
% ylabel("r_l")

%% Echantionnage
rm = zeros(1, len_bk);
for i=1:1:len_bk
    rm(1, i) = rl(1, Fse*i);
end

% subplot(nbr_fig, 1, 5)
% plot((Fse:Fse:len_bk*Fse), rm, "*")
% xlim([0, Fse*(len_bk+1)])
% ylabel("r_m")

%% Decision
b_estim = zeros(1, len_bk);
for i=1:1:len_bk
    if(rm(1, i)>0)
        b_estim(1, i) = 0;
    else
        b_estim(1, i) = 1;
    end
end


subplot(nbr_fig, 1, 1)
plot((0:1:len_bk*Fse-1), sl)
xlim([-Fse, Fse*len_bk])
xlabel("axe du temps")
ylabel("s_l")

% subplot(nbr_fig, 1, 3)
% plot((0:1:len_bk*Fse-1),yl)
% xlim([-Fse, Fse*len_bk])
% ylabel("y_l")

subplot(nbr_fig, 1, 2)
plot(rl)
xlabel("Axe du temps")
ylabel("r_l")

subplot(nbr_fig, 1, 3)
plot((Fse:Fse:len_bk*Fse), rm, "*b")
xlim([0, Fse*(len_bk+1)])
xlabel("Axe du temps")
ylabel("r_m")

figure
subplot(nbr_fig, 1, 1)
plot((0:Fse:(len_bk-1)*Fse), bk, "*r")
xlim([-Fse, len_bk*Fse])
xlabel("Axe du temps")
ylabel("Bits en entrée (b_k)")

subplot(nbr_fig, 1, 2)
plot((Fse:Fse:len_bk*Fse), rm, "*b")
xlim([0, Fse*(len_bk+1)])
xlabel("Axe du temps")
ylabel("r_m")

subplot(nbr_fig, 1, 3)
plot((Fse:Fse:len_bk*Fse), b_estim, "*r")
xlim([0, Fse*(len_bk+1)])
xlabel("Axe du temps")
ylabel("Bits estimés")


