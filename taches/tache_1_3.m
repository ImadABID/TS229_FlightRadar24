%% Init
clc;
clear all;

%% Params

Fe = 20 * 10e6; %Hz
Fse = 20;
Fs = Fe/Fse;

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
p_ada = repmat(p_ada, 1, len_bk);

%figure, plot(p_ada);

%rl = yl .* p_ada;
figure, plot(rl);

%% Echantionnage
rm = zeros(1, len_bk);
for i=1:1:len_bk
    rm(1, i) = max(rl(1, Fse*(i-1)+middle+1), rl(1, Fse*(i-1)+middle-1));
end

%% Decision
b_estim = zeros(1, len_bk);
for i=1:1:len_bk
    if(rm(1, i)>0)
        b_estim(1, i) = 1;
    else
        b_estim(1, i) = 0;
    end
end
