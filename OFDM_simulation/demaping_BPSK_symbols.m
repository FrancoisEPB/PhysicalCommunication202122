function [data] = demaping_BPSK_symbols(data)
%DEMAPING_BPSK SYMBOLS Demaps complex BSPK symbols into bits
%   Detailed explanation goes here
nbits = length(data);

for i=1:nbits
    if real(data(i))<0
        data(i)=0;
    elseif real(data(i))>0
        data(i)=1;
    end
end
end

