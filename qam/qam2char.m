function str = qam2char(modded, symbolmap, size)
    demod = qamdemod(modded, size, symbolmap);
    str = qamtochar(demod);
end