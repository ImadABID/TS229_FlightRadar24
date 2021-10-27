function cor = is_it_a_packet(rl_prembule, sp)

       
        sp_square_integral = sum(abs(sp).^2);
        rl_square_integral = sum(abs(rl_prembule).^2);
        rl_sp_integral = sum(rl_prembule.*sp);  
        
        cor = rl_sp_integral / ( sqrt(sp_square_integral) * sqrt(rl_square_integral) );
        
end