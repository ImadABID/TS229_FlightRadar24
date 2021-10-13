function cor = correlation(yl, sp, delta_t)
        sp_len = length(sp);
        
        sp_square_integral = sum(abs(sp).^2);
        yl_square_integral = sum(abs(yl(delta_t:sp_len+delta_t-1)).^2);
        yl_sp_integral = sum(yl(delta_t:sp_len+delta_t-1).*sp);  
        
        cor= yl_sp_integral/(sqrt(sp_square_integral)*sqrt(yl_square_integral));
end