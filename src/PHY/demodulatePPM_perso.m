function bits = demodulatePPM_perso(packet,Fse)

    % p_ada def
    middle = floor(Fse/2);
    p_ada = [0.5 * ones(1,middle), -0.5 * ones(1,Fse-middle)];
    
    % sig len
    len_sig = size(packet);
    len_sig = floor(len_sig(1,2)/Fse);
    
    rl = conv(packet, p_ada);
    
    rm = zeros(1, len_sig);
    for i=1:1:len_sig
        rm(1, i) = rl(1, Fse*i);
    end
    
    bits = zeros(1, len_sig);
    for i=1:1:len_sig
        if(rm(1, i)>0)
            bits(1, i) = 0;
        else
            bits(1, i) = 1;
        end
    end
end