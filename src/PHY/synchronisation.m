function yl_sync = synchronisation(r_l, delta_t, sp_len, sl_len)
    yl_sync = sqrt(r_l(1+delta_t+sp_len:1:delta_t+sp_len+sl_len));
end