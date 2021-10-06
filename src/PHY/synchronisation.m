function yl_sync = synchronisation(y_l, delta_t, delta_f, sp_len, sl_len)
    yl_sync = y_l(1+delta_t+sp_len:delta_t+sp_len+sl_len).*exp(-1j*2*pi*delta_f*[1+delta_t+sp_len:delta_t+sp_len+sl_len]);
end