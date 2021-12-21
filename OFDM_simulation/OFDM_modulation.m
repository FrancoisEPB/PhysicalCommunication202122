function [Xr] = OFDM_modulation(x,n_f)
%OFDM modulation of an incoming sequence
%   x : input sequence
%   n_f : number of sub-carriers
%   OFDM_symbol_size : size in bits of the OFDM symbols
nbits = length(x);
symbol_size = nbits/n_f; % indicates the order of the ifft
if mod(nbits,symbol_size) ==0
    xr = reshape(x,symbol_size,n_f);
else 
    x = [x zeros(1,mod(nbits,symbol_size))]; %padding zeros
    nbits = length(x);symbol_size = nbits/n_f; %adjusting bit number
    xr = reshape(x,symbol_size,n_f); %reshape for the ifft
end

 
X = ifft(xr, symbol_size,1); 
Xr = reshape(X,1,nbits);
end


