%% Init
clc;
clear all;
close all;
warning('off','all') % disable warnings (crc decoder)

addpath("../MAC/");
addpath("../PHY/");
addpath("../General/");
addpath("../../data/");

%% Params

Fe = 20 * 10e6; %Hz
Te = 1/Fe;
Fse = 4; middle = floor(Fse/2);
Fs = Fe/Fse;

%position d'antenne
refLon = -0.6055;
refLat = 44.8066;

packet_size = 112; % without preambule

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

%Bdx
xmax = 0.7128;
xmin = -1.3581;
ymax = 45.1683;
ymin = 44.4542;


nbr_pts = 4*1000000;
Cor = zeros(1, nbr_pts);

cor_index = 1;

fprintf("Working . . .\n");

for ic=1:1:nbr_col
    il = 1;
    while il < nbr_lig - 120*Fse && cor_index < nbr_pts
        fprintf("(%d, %d)\n", il, ic);
        cor = is_it_a_packet(buffer(il:1:il+8*Fse-1, ic)', sp);
        Cor(1, cor_index) = cor;
        cor_index = cor_index + 1;
        
        
        
        il = il +1;
    end
end

figure, plot(Cor);
