function [X, f] = Mon_Welch_perso(x, Nfft, Fe)

    FFT_min = 100;
    
    len_x = size(x); len_x = len_x(1,2);

    if len_x < FFT_min * Nfft
        error("Mon_Welch_perso : Insuffisant data");
    end
    
    nbr_ech = floor(len_x/Nfft);
    DSP_realisations = zeros(nbr_ech, Nfft);
    
    for iech=0:1:nbr_ech-1
        DSP_realisations(iech+1, 1:1:Nfft) = abs(fftshift(fft(x(1, iech*Nfft+1:1:(iech+1)*Nfft), Nfft))).^2;
    end
    
    df = Fe/Nfft;
    
    X = mean(DSP_realisations) ./Nfft ./Fe;
    f = -Fe/2+df:df:Fe/2;
    
end