function Bits_estimes = Synchronisation(Bits_encodes)
        %% Params
        Te = 1e-6;
        Tp = 8e-6;
        Fse = 20;
        sigma = 0.8;
        middle = floor(Fse/2);
        sp = [P, P, zeros(1, 4*middle), P, P, zeros(1, 6*middle)]; %preambule

        % Modulation PPM
        sl = modulatePPM(Bits_encodes', Fse);

        %Ajout du préambule
        sl_preambule = [sp, sl];
        nl = normrnd(0, sigma, size(sl));
        yl = sl_preambule + nl;
        rl = abs(yl).^2;
        
        intercorr = xcorr(rl, sp);
        
        
        
        
        
end









