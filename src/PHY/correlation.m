function cor = correlation(rl, sp, delta_t)
        sp_len = length(sp);
        
        sp_square_integral = sum(abs(sp).^2);
        rl_square_integral = sum(abs(rl(delta_t:sp_len+delta_t-1)).^2);
        rl_sp_integral = sum(rl(delta_t:sp_len+delta_t-1).*sp);  
        
        cor= rl_sp_integral/(sqrt(sp_square_integral)*sqrt(rl_square_integral));
end