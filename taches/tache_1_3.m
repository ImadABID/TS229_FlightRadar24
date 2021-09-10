%% Init
clc;
clear all;

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;
Nb=1e3;

% p def
middle = floor(Fse/2);
P = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];

%% input
bk = [1, 0, 0, 1, 0];

%% PPM Modulation
sl = [];
len_bk = size(bk); len_bk = len_bk(1,2);

for i=1:1:len_bk
    if(bk(1, i) == 0)
        sl = [sl, 0.5 + P];
    else
        sl = [sl, 0.5 - P];
    end
end


%% Canal
nl = zeros(1, Fse*len_bk);
yl = sl + nl;


%% Filtre adapte
p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];

%rl = conv(yl, p_ada);
rl = conv(yl, p_ada, 'same');
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
trans_fourier_autocorr=fft(p_ada);
Eg = sum(abs(trans_fourier_autocorr).*abs(trans_fourier_autocorr));
sigma2 =  Eg ./(Nb * eb_n0);
%% Probabilité d'erreur binaire
Pb=qfunc(sqrt(2*eb_n0));
TEB=zeros(size(eb_n0));
for i=1:length(eb_n0)
     error_cnt=0;
     bit_cnt=0;
     while error_cnt < 100
         Sb=randi([0,1],1,Nb);
         n_l=zeros(1, Fse*Nb);
         s_l=[];
         for k=1:1:Nb
             if(Sb(k) == 0)
                s_l = [s_l, 0.5 + P];
             else
                s_l = [s_l, 0.5 - P];
             end
         end
         y_l = s_l + n_l;
         p_adap = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];
         r_l = conv(y_l, p_adap, 'same');
         r_m = zeros(1, Nb);
         for pp=1:1:Nb
              r_m(pp) = r_l(pp*Fse);
         end
         b_estime = zeros(1, Nb);
         for kk=1:1:Nb
              if(r_m(kk)>0)
                   b_estime(kk) = 1;
              else
                   b_estime(kk) = 0;
              end            
         end
         errors=0;
         for jj=1:Nb
              if Sb(jj) ~= b_estime(jj)
                  errors = errors+1;
              end
         end
         error_cnt = error_cnt + errors;
         bit_cnt = bit_cnt + Nb;         
    end
    TEB(i) = error_cnt/bit_cnt;
end

figure, plot(sl)
figure, plot(rl)
figure, plot(rm)
figure, 
semilogy(eb_n0_dB, Pb)
hold on 
semilogy(eb_n0_dB, TEB)
hold off
xlabel('Eb/N0 (dB)');
ylabel('TEB,Pb');
legend('Pb Theorique','TEB','Location','southwest');