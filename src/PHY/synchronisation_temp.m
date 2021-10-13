function yl_sync = synchronisation_temp(y_l, delta_t, sp_len, sl_len, Te)
      yl_sync = y_l(1+delta_t+sp_len:delta_t+sp_len+sl_len);
end