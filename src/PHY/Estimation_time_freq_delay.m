function [temp_delay, freq_delay, cor] = Estimation_time_freq_delay(yl, sp, temp_delay_max, freq_delay_max)
    sp_len = length(sp); 
    sp_square_integral = sum(abs(sp).^2);
    
    temp_delay = 0;
    freq_delay = 0;
    
    cor = zeros(freq_delay_max, temp_delay_max);
    yl_square_integral = zeros(1, temp_delay_max);
    yl_sp_integral = zeros(1, temp_delay_max);
    for t=1:temp_delay_max
        for f=1:freq_delay_max     
            yl_square_integral(t) = sum(abs(yl(1+t:sp_len+t)).^2);
            yl_sp_integral(t) = sum(yl(1+t:sp_len+t).*sp.*exp(1j*2*pi*f*t));  
            cor(t, f) = yl_sp_integral(t)/(sqrt(sp_square_integral)*sqrt(yl_square_integral(t)));
        end
    end
    maxcor = max(max(abs(cor)));
    for t=1:temp_delay_max
        for f=1:freq_delay_max     
           if maxcor == abs(cor(t,f))
               temp_delay = t;
               freq_delay = f;
           end
        end
    end
        
end