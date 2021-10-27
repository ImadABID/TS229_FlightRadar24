function temp_delay = Estimation_time_delay(rl, sp, temp_delay_max)
    
    sp_len = length(sp);  
    sp_square_sum = sqrt(sum(abs(sp).^2));
    cor = zeros(1, temp_delay_max);
    
    for k=1:temp_delay_max    
        cor(k) =  sum(rl(k + 1 : k + sp_len).*sp)./sum(abs(rl(k + 1 : k + sp_len)).^2);
    end
    cor = cor / sp_square_sum;
    [~, temp_delay] = max(cor);
    
end