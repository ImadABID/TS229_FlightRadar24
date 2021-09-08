%% Init
clc;
clear all;

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;
Nb=10e3;

% p def
middle = floor(Fse/2);
p = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];

%% input
bk = [1, 0, 0, 1, 0];

%% PPM Modulation
sl = [];
len_bk = size(bk); len_bk = len_bk(1,2);

for i=1:1:len_bk
    if(bk(1, i) == 0)
        sl = [sl, 0.5 + p];
    else
        sl = [sl, 0.5 - p];
    end
end

%figure, plot(sl);

%% Canal
nl = zeros(1, Fse*len_bk);
yl = sl + nl;

%figure, plot(yl);

%% Filtre adapte
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];

rl = conv(yl, p_ada);

%% Echantionnage
rm = zeros(1, len_bk);
for i=1:1:len_bk
    rm(1, i) = rl(1, Fse*i);
end

%% Decision
b_estim = zeros(1, len_bk);
for i=1:1:len_bk
    if(rm(1, i)>0)
        b_estim(1, i) = 0;
    else
        b_estim(1, i) = 1;
    end
end
%% Taux d'erreur binaire
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
