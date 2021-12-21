function y_CFO=add_CFO(y,CFO,Nfft)
% add CFO (carrier frequency offset)
% y : Received signal
% CFO = IFO (integral CFO) + FFO (fractional CFO)
% Nfft = FFT size
nn=0:length(y)-1; 
y_CFO = y.*exp(1j*2*pi*CFO*nn/Nfft); % Eq.(5.7)y_CFO
end