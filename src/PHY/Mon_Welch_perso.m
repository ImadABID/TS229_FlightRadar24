function [X, f] = Mon_Welch_perso(x, Nfft, Fe)

    FFT_min = 100;
    
    len_x = size(x); len_x = len_x(1,2);

    if len_x < FFT_min * Nfft
        error("Mon_Welch_perso : Insuffisant data");
    end
    
    DSP_realisations = [];
    
    for iech=1:Nfft:len_x
        if(iech+Nfft <= len_x)
            x_ech = x(1, iech:iech+Nfft);
            DSP_realisations = [DSP_realisations; abs(fftshift(fft(x_ech, Nfft))).^2];
        end
    end
    
    df = Fe/Nfft;
    
    X = mean(DSP_realisations) ./Nfft ./Fe;
    f = -Fe/2+df:df:Fe/2;
end