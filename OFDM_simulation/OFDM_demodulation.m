function [yr] = OFDM_demodulation(Yn,OFDM_symbol_size,n_f)
%OFDM_DEMODULATION Deodulates an OFDM signal received
% Yn : complex received signal
%OFDM_symbol_size : number of bits contained in a OFDM_symbol = n_sdymbol_bits/n_f
%n_f : number of sub carriers

Y = reshape(Yn,OFDM_symbol_size,n_f);
y = fft(Y,OFDM_symbol_size);
yr = reshape(y,1,nbits);   

end

