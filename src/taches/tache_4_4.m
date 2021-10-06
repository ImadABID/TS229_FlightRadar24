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
packet_size = 112; %Ts

%% generating the packet
packet = randi([0 1], 1, packet_size);

%% Modulation 
sl = modulatePPM(packet, Fse);

%% Preambule
sp_len = 8*Fse; %Te
sp = zeros(1, sp_len);
sp(1:1:middle) = ones(1, middle);
sp(Fse+1:1:Fse+middle) = ones(1, middle);
sp(3*Fse+middle:1:4*Fse-1) = ones(1, middle);
sp(4*Fse+middle:1:5*Fse-1) = ones(1, middle);

sl = [sp, sl];

%% Noise & decalage

sigma = 0.5;

% Choosing delays
temp_delay_max = 100; % Te
freq_delay_max = 1e3; % Hz

temp_delay = randi([0 temp_delay_max], 1, 1);
freq_delay = randi([-freq_delay_max freq_delay_max], 1, 1);


% Noisy sending window
sending_window_len = packet_size*Fse+temp_delay_max+sp_len+100; % Te
nl = normrnd(0,sigma, [1, sending_window_len]);
yl = nl;
%yl = zeros(1, length(nl));    without noise

k = 1;
for i=1+temp_delay:1:temp_delay+packet_size*Fse+sp_len
    yl(i) = nl(i)+ sl(k) .* exp(-1j*2*pi*freq_delay*(k-1)*Te);
    %yl(i) = sl(k) .* exp(-1j*2*pi*freq_delay*(k-1)*Te); without noise
    k = k+1;
end

%% |yl|.^2

rl = abs(yl).^2;

%% Estimation of time delay
rl_Tp = rl(1:sp_len);
[Normalized_Corr, delta_t] = xcorr(rl_Tp, sp, 'normalized');
Max_Corr = max(abs(Normalized_Corr));
estimated_delay = 0;
for k=1:length(delta_t)
    if Normalized_Corr(k) == Max_Corr
        estimated_delay = delta_t(k);
    end
end       
plot(delta_t, abs(Normalized_Corr))

%% Sync
yl_sync = synchronisation(rl, temp_delay, sp_len, packet_size*Fse);


%% Demodulation
packet_estim = demodulatePPM(yl_sync, Fse);

if packet_estim == packet
    fprintf("Ok\n");
else
    fprintf("Not Ok\n");
end

%% Calcul de TEB 
Eb = 1/8 * Fse;
SNR_dB = 0:0.5:10;
SNR = 10.^(SNR_dB/10);
SNR_len = length(SNR);
Pb = 0.5*erfc(sqrt(2*SNR));

nbr_err_threshold = 100;
nbr_err_max_iteration = 1000;


TEB = zeros(1, SNR_len);
for i=1:1:SNR_len
    sigma = sqrt(Eb/(2*SNR(i)));
    nbr_err = 0;
    nbr_bits = 0;
    j=0;
    while nbr_err < nbr_err_threshold && j < nbr_err_max_iteration
        temp_delay = randi([0 temp_delay_max], 1, 1);
        freq_delay = randi([-freq_delay_max freq_delay_max], 1, 1);
        sending_window_len = packet_size*Fse+temp_delay_max+sp_len+100; % Te
        nl = normrnd(0,sigma, [1, sending_window_len]);
        sl = modulatePPM(packet, Fse);
        sl_len = length(sl);
        sl = [sp, sl, zeros(1, 200)];
        yl = sl + nl;
        k = 1;
        for i=1+temp_delay:1:temp_delay+packet_size*Fse+sp_len
            %yl(i) = nl(i)+ sl(k) .* exp(-1j*2*pi*freq_delay*(k-1)*Te);
             yl(i) = nl(i) + sl(k) .* exp(-1j*2*pi*freq_delay*(k-1)*Te); %without noise
             k = k+1;
        end
        rl = abs(yl).^2;
        yl_synch = synchronisation(rl, temp_delay, sp_len, sl_len);
        packet_estim = demodulatePPM(yl, Fse);
        nbr_err = nbr_err + sum(packet ~= packet_estim(1:packet_size));
        nbr_bits = nbr_bits + packet_size;
        j = j+1;
    end

    TEB(i) = nbr_err/nbr_bits;
end

figure()
loglog(SNR, TEB(1:SNR_len))
% hold on
% loglog(SNR, Pb)
% hold off
% xlabel('Eb/N0');
% ylabel('TEB,Pb');
% legend('TEB','Pb théorique','Location','southwest');






