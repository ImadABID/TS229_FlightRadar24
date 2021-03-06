function [temp_delay, freq_delay] = Estimation_time_freq_delay(yl, sp, temp_delay_max, freq_delay_max)
    sp_len = length(sp);  
    sp_square_sum = sqrt(sum(abs(sp).^2));
    
    cor = zeros(freq_delay_max, temp_delay_max);

    for f=1:freq_delay_max+1 
        for t=1:temp_delay_max+1
            cor(f, t) =  sum(yl(t + 1 : t + sp_len)* exp(-1j*2*pi*f*t).*sp)./sum(abs(yl(t + 1 : t + sp_len)).^2);
        end
    end
     
    cor = cor/sp_square_sum;
    
    [~, li] = max(abs(cor(:)));
    
    freq_delay = floor(li/temp_delay_max);
    temp_delay = mod(li, freq_delay);

end