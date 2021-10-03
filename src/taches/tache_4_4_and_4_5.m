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
sending_window_len = packet_size*Fse+temp_delay_max+sp_len; % Te
nl = normrnd(0,sigma, [1, sending_window_len]);
yl = nl;

k = 1;
for i=1+temp_delay:1:temp_delay+packet_size*Fse+sp_len
    yl(i) = nl(i)+ sl(k) .* exp(-1j*2*pi*freq_delay*(k-1)*Te);
    k = k+1;
end

%% |yl|.^2

rl = abs(yl).^2;

%% Sync
temp_delay_estim = temp_delay_estimation(rl, sp, temp_delay_max);
yl_sync = synchronisation(rl, temp_delay_estim, sp_len, packet_size*Fse);

%% Demodulation
packet_estim = demodulatePPM(yl_sync, Fse);

if packet_estim == packet
    fprintf("Ok\n");
else
    fprintf("Not Ok\n");
end
