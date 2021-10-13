function yl_sync = synchronisation(y_l, delta_t, sp_len, sl_len, Te)
%     yl_sync = y_l(1+delta_t+sp_len:delta_t+sp_len+sl_len).*exp(1j*2*pi*delta_f*Te.*(delta_t+sp_len:delta_t+sp_len+sl_len-1));
      yl_sync = y_l(1+delta_t+sp_len:delta_t+sp_len+sl_len);
end