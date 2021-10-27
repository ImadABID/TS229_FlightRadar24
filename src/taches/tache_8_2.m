%% Init
clc;
clear all;
close all;
warning('off','all') % disable warnings (crc decoder)

addpath("../PHY/");
addpath("../MAC/");

%% Params

Fe = 20 * 10e6; %Hz
Te = 1/Fe;
Fse = 20; middle = floor(Fse/2);
Fs = Fe/Fse;

%position d'antenne
refLon = -0.6055;
refLat = 44.8066;

packet_size = 112; % without preambule

SNR = 6;
%sigma = sqrt(Eb/(2*SNR));
sigma = 0;

% Preambule
sp_len = 8*Fse; %Te
sp = zeros(1, sp_len);
sp(1:1:middle) = ones(1, middle);
sp(Fse+1:1:Fse+middle) = ones(1, middle);
sp(3*Fse+middle:1:4*Fse-1) = ones(1, middle);
sp(4*Fse+middle:1:5*Fse-1) = ones(1, middle);

% Buffer
buffer = load('../../data/buffers.mat');
buffer = abs(buffer.buffers).^2;


[nbr_lig, nbr_col] = size(buffer);
nbr_lig = 10000;

Register_tab = [];

nbr_packets = 0;
valid_corr_packets = 0;
for ic=1:1:nbr_col
    il = 1;
    while il < nbr_lig - 8*20
        if correlation(buffer(:, ic)', sp, il, 0.9)
            valid_corr_packets = valid_corr_packets + 1;
            packet_decoded = demodulatePPM(buffer(il+8*20:1:il+120*20-1, ic)', Fse);
            registre = bit2registre(packet_decoded, refLon, refLat);
            if isfield(registre, "longitude")
                Register_tab = [Register_tab, registre];
                il = il + 120*8;
                fprintf("A packet was found at (%d,%d)\n", il, ic);
                nbr_packets = nbr_packets + 1;
            else
                fprintf("(%d,%d) valid_corr_packets = %d, nbr_packets = %d\n", il, ic, valid_corr_packets, nbr_packets);
                il = il+1;
            end
            
        else
            fprintf("(%d,%d) valid_corr_packets = %d, nbr_packets = %d\n", il, ic, valid_corr_packets, nbr_packets);
            il = il+1;
        end
    end
end

airplane_Address = [];
LON = [];
LAT = [];


%{
for i=1:1:nbr_packets
    reg_i = find(Register_tab.address == Register_tab(1).address);
    
end
%}

%reg_i = find(Register_tab.address == Register_tab(1).address);

