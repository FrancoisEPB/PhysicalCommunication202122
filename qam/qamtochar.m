function str = qamtochar(demodout)
    chars = zeros(1, length(demodout)/3);
    idx = 1;
    for i=1:3:length(demodout)
        x1 = demodout(i);
        x2 = demodout(i+1);
        x3 = demodout(i+2);
        original = x1*256 + x2*16 + x3;
        bits = int2bit(original, 12);
        hamming = checkhamming(bits);
        chars(idx) = bit2int(hamming, 8);
        idx = idx + 1;
    end
    str = char(chars);
end