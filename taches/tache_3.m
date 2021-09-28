%% Init
clc;
clear all;
close all;

addpath("../src/PHY");

%% Params
Fse = 20;
Nb = 88;
ctrl = 24;
sigma = 0.8;
Pg = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]; %generator
packet = randi([0 1], Nb, 1);

%%Codeur CRC
CRCGen = crc.generator(Pg);
CRCDet = crc.detector(Pg);
EncPacket = generate(CRCGen, packet); %ajout des bits de contrôle

sl = modulatePPM(EncPacket', Fse);
nl = normrnd(0, sigma, size(sl));
yl = sl + nl;
packet_estim = demodulatePPM(yl, Fse);

%%décodeur CRC
[DecPacket, errors] = detect(CRCDet,packet_estim');

if errors
    fprintf("Le message est intègre\n");
else
    fprintf("Le message n'est pas intègre\n");
end
