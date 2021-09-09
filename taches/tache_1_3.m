%% Init
clc;
clear all;
close all;

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;
Nb=10e3;

% p def
middle = floor(Fse/2);
p = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];


figure()
nbr_fig = 6;

%% input
bk = [1, 0, 0, 1, 0];
len_bk = size(bk); len_bk = len_bk(1,2);

subplot(nbr_fig, 1, 1)
plot((0:Fse:(len_bk-1)*Fse), bk, "*")
xlim([-Fse, len_bk*Fse])
ylabel("b_k")

%% PPM Modulation
sl = [];

for i=1:1:len_bk
    if(bk(1, i) == 0)
        sl = [sl, 0.5 + p];
    else
        sl = [sl, 0.5 - p];
    end
end

subplot(nbr_fig, 1, 2)
plot((0:1:len_bk*Fse-1), sl)
xlim([-Fse, Fse*len_bk])
ylabel("s_l")

%% Canal
nl = zeros(1, Fse*len_bk);
yl = sl + nl;

subplot(nbr_fig, 1, 3)
plot((0:1:len_bk*Fse-1),yl)
xlim([-Fse, Fse*len_bk])
ylabel("y_l")

%% Filtre adapte
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];

rl = conv(yl, p_ada);

subplot(nbr_fig, 1, 4)
plot(rl)
ylabel("r_l")

%% Echantionnage
rm = zeros(1, len_bk);
for i=1:1:len_bk
    rm(1, i) = rl(1, Fse*i);
end

subplot(nbr_fig, 1, 5)
plot((Fse:Fse:len_bk*Fse), rm, "*")
xlim([0, Fse*(len_bk+1)])
ylabel("r_m")

%% Decision
b_estim = zeros(1, len_bk);
for i=1:1:len_bk
    if(rm(1, i)>0)
        b_estim(1, i) = 0;
    else
        b_estim(1, i) = 1;
    end
end

subplot(nbr_fig, 1, 6)
plot((Fse:Fse:len_bk*Fse), b_estim, "*")
xlim([0, Fse*(len_bk+1)])
ylabel("b_{estime}")

%% Taux d'erreur binaire
%{
eb_n0_dB = 0:10;
eb_n0 = 10.^(eb_n0_dB/10);
TEB=zeros(size(eb_n0));
for i=1:length(eb_n0)
     error_cnt=0;
     bit_cnt=0;
     while error_cnt < 100
         Sb=randi([0,1],1,Nb);
         len_Sb=length(Sb);
         nl = zeros(1, Fse*len_Sb);
         for k=1:1:len_Sb
             if(Sb(1, k) == 0)
                sl = [sl, 0.5 + p];
             else
                sl = [sl, 0.5 - p];
             end
         end
         sl=sl(1:len_Sb*Fse);
         yl = sl + nl;
         p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];
         rl = conv(yl, p_ada);
         rm = zeros(1, len_Sb);
         for p=1:1:len_Sb
              rm(1, p) = rl(1, Fse*(p-1)+1);
         end
         for kk=1:1:len_Sb
              if(rm(1, kk)>0)
                   b_estim(1, kk) = 1;
              else
                   b_estim(1, kk) = 0;
              end            
         end
         errors=0;
         for jj=1:Nb
              if Sb(jj) ~= b_estim(1, jj)
                  errors = errors+1;
              end
         end
         error_cnt = error_cnt + errors;
         bit_cnt = bit_cnt + len_Sb;         
    end
    TEB(i) = error_cnt/bit_cnt;
 end 
%}
