%% Init
clc;
clear all;
close all;

addpath("../PHY/");

%% Params

Fe = 20 * 10e6; %Hz
Te = 1/Fe;
Fse = 20; middle = floor(Fse/2);
Fs = Fe/Fse;
Eb = 1/8 * Fse;

% nbr_err
nbr_err_threshold = 100;
nbr_err_max_iteration = 1e8;
packet_size = 112;

% SNR
SNR_len = 10;
SNR_max = 10;
SNR = (0:SNR_max/(SNR_len-1):SNR_max);

% Preambule
sp_len = 8*Fse; %Te
sp = zeros(1, sp_len);
sp(1:1:middle) = ones(1, middle);
sp(Fse+1:1:Fse+middle) = ones(1, middle);
sp(3*Fse+middle:1:4*Fse-1) = ones(1, middle);
sp(4*Fse+middle:1:5*Fse-1) = ones(1, middle);

% delays
temp_delay_max = 100; % Te
freq_delay_max = 1e3; % Hz

% sending_window_len
sending_window_len = packet_size*Fse+temp_delay_max+sp_len; % Te

%% Pb théorique
Pb = 0.5*erfc(sqrt(2*SNR));

%% TEB
TEB = zeros(1, SNR_len);
for i=1:1:SNR_len
    sigma = sqrt(Eb/(2*SNR(i)));
    nbr_err = 0;
    nbr_bits = 0;
    j=0;
    while nbr_err < nbr_err_threshold && j < nbr_err_max_iteration
        
        packet = randi([0 1], 1, packet_size);
        sl = modulatePPM(packet, Fse);
        
        % adding preambule
        sl = [sp, sl];
        
        % Choosing delays
       temp_delay = randi([0 temp_delay_max], 1, 1);
        freq_delay = randi([-freq_delay_max freq_delay_max], 1, 1);
        
        % Noisy sending window
        nl = normrnd(0,sigma, [1, sending_window_len]);
        yl = nl;
        
        k = 1;
        for ii=1+temp_delay:1:temp_delay+packet_size*Fse+sp_len
            yl(ii) = nl(ii)+ sl(ii-temp_delay) .* exp(-1j*2*pi*freq_delay*ii);
            k = k+1;
        end

        % |yl|.^2

         rl = abs(yl).^2;

        % Estimation du décalage temporel
        temp_delay_estim = Estimation_time_delay(rl, sp, temp_delay_max);

        %synchronisation

        yl_sync = synchronisation_temp(rl, temp_delay_estim, sp_len, packet_size*Fse);

        packet_estim = demodulatePPM(yl_sync, Fse);
        nbr_err = nbr_err + sum(packet ~= packet_estim);
        nbr_bits = nbr_bits + packet_size;
        j = j+1;
        
        fprintf("progress(percent)=%f, iteration(%d:%d), sigma = %f, SNR = %f,  nbr_err = %d, temp_delay_estim_err=%d\n", i/SNR_len*100, i, j, sigma, SNR(i), nbr_err, temp_delay - temp_delay_estim);
        
    end

    TEB(i) = nbr_err/nbr_bits;
end

%% Ploting
figure()
TEB_cst = ones(1, length(SNR)) * 10^-3;

loglog(SNR, Pb, SNR, TEB, SNR, TEB_cst, '--')

xlabel('Eb/N0');
ylabel('TEB,Pb');
legend('Pb Theorique','TEB', 'TEB fixe', 'Location','Southwest');