function temp_delay = Estimation(yl, sp, temp_delay_max, sl_len)
    Fse = 20;
    sp_len = length(sp); 
    Tp = sp_len; 
    numerateur_c = xcorr(yl,sp);
    numerateur = numerateur_c(length(yl): end - Tp - sl_len - Fse);

    
    Eg_sp = sum(abs(sp).^2);
    Egs_yl = zeros(1, length(yl) - Tp - sl_len - Fse);
    for dec_t = 0 : length(yl) - Tp - sl_len - Fse -  1
        Egs_yl(dec_t+1) = sum(abs(yl(dec_t+1:dec_t+1+Tp)).^2);
    end
    denominateur = sqrt(Eg_sp) * sqrt(Egs_yl);
%     numerateur = numerateur(1:length(denominateur));
    corr = numerateur ./ denominateur;
    [val, index] = max(corr);
    temp_delay = index - 1;
end