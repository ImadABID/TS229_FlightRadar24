function char = decode_char(bits)
    switch bits(1,5)+2*bits(1,6)
        case 0
            char = 'A' + sum(bits(1:1:4) .* (2.^(0:1:3))) - 1;
           
        case 1
            char = 'P' + sum(bits(1:1:4) .* (2.^(0:1:3)));
            
        case 2
            char = ' ';
            
        case 3
            char = '0' + sum(bits(1:1:4) .* (2.^(0:1:3)));
            
    end
            
end
