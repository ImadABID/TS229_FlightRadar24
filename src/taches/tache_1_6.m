%% Init
clc;
clear all;
close all;

addpath("../PHY/");

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;
Eb = 1/8 * Fse;

nbr_err_threshold = 100;
nbr_err_max_iteration = 1000;
packet_size = 100000;

SNR_len = 50;
SNR_max = 4;
SNR = (0:SNR_max/(SNR_len-1):SNR_max);

Pb = 0.5*erfc(sqrt(2*SNR));

TEB = zeros(1, SNR_len);
for i=1:1:SNR_len
    sigma = sqrt(Eb/(2*SNR(i)));
    nbr_err = 0;
    nbr_bits = 0;
    j=0;
    while nbr_err < nbr_err_threshold && j < nbr_err_max_iteration
        packet = randi([0 1], 1, packet_size);
        sl = modulatePPM(packet, Fse);
        nl = normrnd(0,sigma, [1, packet_size*Fse]);
        yl = sl + nl;
        packet_estim = demodulatePPM(yl, Fse);
        nbr_err = nbr_err + sum(packet ~= packet_estim);
        nbr_bits = nbr_bits + packet_size;
        j = j+1;
        fprintf("progress(percent)=%f, iteration(%d:%d), sigma = %f, SNR = %f,  nbr_err = %d\n", i/SNR_len*100, i, j, sigma, SNR(i), nbr_err);
    end

    TEB(i) = nbr_err/nbr_bits;
end

figure()
loglog(SNR, TEB)
hold on
loglog(SNR, Pb)
xlabel('Eb/N0');
ylabel('TEB,Pb');
legend('Pb Theorique','TEB','Location','southwest');