function [temp_delay, freq_delay] = Estimation_time_freq_delay(yl, sp, temp_delay_max, freq_delay_max)
    sp_len = length(sp); 
    sp_square_integral = sum(abs(sp).^2);
    
    cor = zeros(freq_delay_max, temp_delay_max);

    for f=1:freq_delay_max+1 
        for t=1:temp_delay_max+1
            yl_square_integral = sum(abs(yl(t:sp_len+t-1)).^2);
            yl_sp_integral = sum(yl(t:sp_len+t-1).*sp.*exp(-1j*2*pi*(f-1)*t));  
            cor(f, t) = yl_sp_integral/(sqrt(sp_square_integral)*sqrt(yl_square_integral));
        end
    end
    
    [~, li] = max(abs(cor(:)));
    
    li = li-1;
    
    freq_delay = floor(li/temp_delay_max);
    temp_delay = mod(li, freq_delay);

end