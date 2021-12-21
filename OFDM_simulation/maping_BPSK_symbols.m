function [BPSK_symbols,bits] = maping_BPSK_symbols(nbits)
%CREATE_BPSK_SYMBOLS Creates a random stream of nbits BPSK symbols reak -1 and +1

bits = randi(2,1,nbits)-1; 
BPSK_symbols = zeros(1,nbits);
for i=1:nbits
    if not(bits(i))
            BPSK_symbols(i) = -1; %placing zero bits at -1 for BPSK
    else
        BPSK_symbols(i) = 1;
    end
end 

end

