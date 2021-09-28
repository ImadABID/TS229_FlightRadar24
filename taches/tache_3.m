%% Init
clc;
clear all;
close all;

addpath("../src/PHY");

%% Params
Fse = 20;
Nb = 88;
ctrl = 24;
middle = floor(Fse/2);
Pg = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1]; %generator
packet = randi([0 1], Nb, 1);

%%Codeur CRC
CRCGen = crc.generator(Pg);
CRCDet = crc.detector(Pg);
EncPacket = generate(CRCGen, packet); %ajout des bits de contrôle

%%modulation PPM
sigma = 1;
sl = modulatePPM(EncPacket', Fse);
%nl = normrnd(0,sigma, [1, length(sl)]);
yl = sl;
%yl(3) = ~yl(3);  
%yl(4) = ~yl(4);  
%yl(111) = ~yl(111);  

%convolution
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];
vl = conv(yl, p_ada);

%echantillonnage
vm = zeros(1, Nb + ctrl);
for k=1:(Nb + ctrl)
    vm(k) = vl(Fse*k);
end

%decision
b_estim = zeros(1, Nb + ctrl);
for k=1:(Nb + ctrl)
    if(vm(k)>0)
        b_estim(k) = 0;
    else
        b_estim(k) = 1;
    end
end

%%décodeur CRC
[DecPacket, errors] = detect(CRCDet,b_estim');


