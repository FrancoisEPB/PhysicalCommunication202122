function output = checkhamming(bits)
    %bits is array of 12 bits
    reversed = flip(bits);
    p1 = [1 3 5 7 9 11];
    p2 = [2 3 6 7 10 11];
    p4 = [4 5 6 7 12];
    p8 = [8 9 10 11 12];
    
    cp1 = parity(p1, reversed);
    cp2 = parity(p2, reversed);
    cp4 = parity(p4, reversed);
    cp8 = parity(p8, reversed);

    wrong = 12 - bit2int([cp1 cp2 cp4 cp8]', 4) + 1;
    if (wrong ~= 13)
        bits(wrong) = xor(bits(wrong), 1);
    end
    output = bits([1 2 3 4 6 7 8 10]);
end

function p = parity(pidxs, bits)
    sum = 0;
    for i=pidxs
        if (bits(i) == 1)
            sum = sum + 1;
        end
    end
    p = rem(sum, 2);
end