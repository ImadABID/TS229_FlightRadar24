function modSig = modulatePPM_perso(sig, Fse)

    % p def
    middle = floor(Fse/2);
    p = [-0.5 * ones(1,middle), 0.5 * ones(1,Fse-middle)];

    % sig len
    len_sig = size(sig);
    len_sig = len_sig(1,2);
    
    % modsig init with zeros
    modSig = zeros(1, len_sig);
    
    % modsig populate with correct data
    for i=1:1:len_sig
        if(sig(1, i) == 0)
            modSig(1, (i-1)*Fse+1 : i*Fse) = 0.5 + p;
        else
            modSig(1, (i-1)*Fse+1 : i*Fse) = 0.5 - p;
        end
    end
    
end