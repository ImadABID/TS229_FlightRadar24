function temp_delay = Estimation_time_delay(rl, sp, temp_delay_max)
    
    sp_len = length(sp); 
    sp_square_integral = sum(abs(sp).^2);
    
    rl_square_integral = zeros(1, temp_delay_max);
    rl_sp_integral = zeros(1, temp_delay_max);
    cor = zeros(1, temp_delay_max);
    
    for k=1:temp_delay_max
        rl_square_integral(k) = sum(abs(rl(1+k:sp_len+k)).^2);
        rl_sp_integral(k) = sum(rl(1+k:sp_len+k).*sp);      
        cor(k) = rl_sp_integral(k)./(sqrt(sp_square_integral)*sqrt(rl_square_integral(k)));
    end
    [~, temp_delay] = max(abs(cor));
    
end