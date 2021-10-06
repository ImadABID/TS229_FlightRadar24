function temp_delay = temp_delay_estimation(rl, sp, temp_delay_max)
    
    sp_len = size(sp); sp_len = sp_len(1,2);
    rl_len = size(rl); rl_len = rl_len(1,2);
    
    if rl_len < sp_len + temp_delay_max
        error("the length of rl must be at least equal to the lenght of sp + mximum temporal delay.");
    end

    corr_table = zeros(1, temp_delay_max);
    
    sp_square_integral = sum(abs(sp));
    rl_square_integral = sum(abs(rl(1:1:sp_len)));
    rl_sp_integral = sum(rl(1:1:sp_len).*sp);
    
    for i=1:1:temp_delay_max
        
        corr_table(1,i) = rl_sp_integral/(sqrt(sp_square_integral)*sqrt(rl_square_integral));
        
        rl_square_integral = rl_square_integral - abs(rl(i))^2  + abs(rl(sp_len+i))^2;
        rl_sp_integral = sum(rl(1+i:1:sp_len+i).*sp);
        
    end
    
    [~, temp_delay] = max(abs(corr_table));
    
    temp_delay = temp_delay - 1;
end