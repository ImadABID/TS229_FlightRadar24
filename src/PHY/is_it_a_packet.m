function [is_it, cor] = is_it_a_packet(rl_prembule, sp, seuil)

        %%

        sp_square_integral = sum(abs(sp).^2);
        rl_square_integral = sum(abs(rl_prembule).^2);
        rl_sp_integral = sum(rl_prembule.*sp);  
        
        cor = rl_sp_integral / ( sqrt(sp_square_integral) * sqrt(rl_square_integral) );
        
        if cor > seuil
            is_it = 1;
        else
            is_it = 0;
        end           
end