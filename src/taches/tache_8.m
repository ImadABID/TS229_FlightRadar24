%% Init
clc;
clear all;
close all;

addpath("../../data/");
addpath("../MAC/");
addpath("../General/");

%% parametres
sp_len = 8*Fse; 
sp = zeros(1, sp_len);
sp(1:1:middle) = ones(1, middle);
sp(Fse+1:1:Fse+middle) = ones(1, middle);
sp(3*Fse+middle:1:4*Fse-1) = ones(1, middle);
sp(4*Fse+middle:1:5*Fse-1) = ones(1, middle);

seuil = 0.8;

buffers = load("buffers.mat");
buffers = (buffers.buffers)';
[columns, lines] = size(buffers);
%buff1 = buffers(1,:);

for k=1:columns
    rl = abs(buffers(k,:)).^2;
    for l=1:lines
        if correlation(rl, sp, l, seuil) == 0;
            
end