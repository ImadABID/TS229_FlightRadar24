%% bit2registre
% bit2registre est une fonciton qui prend un paquet lu sur le canal et en
% extrait les informations.
%
% La syntaxte est la suivante : registre = decodeADSB(bitPacketCRC)
%
% bitPacketCRC est le message re�u (sans le pr�ambule), c'est un message
% binaire de 112 bits
%
% la sortie est un registre contenant ...

function registre = bit2registre_perso(bitPacketCRC,refLon,refLat)

    Pg = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];
    CRCDet = crc.detector(Pg);
    [DecPacket, errors] = detect(CRCDet,bitPacketCRC');
    DecPacket = [zeros(1,8) DecPacket'];
    
    if errors
        registre = 0;
    else
        
        registre.type = sum(DecPacket(9:1:13) .* (2.^(0:1:4)));
        registre.adresse = DecPacket(17:1:40);
        registre.format = sum(DecPacket(41:1:45) .* (2.^(0:1:4)));
        
        if ismember(registre.format, (1:1:4))
            % Decode Nom
            registre.nom = zeros(1, 8);
            
            for i=(1:1:8)
                registre.nom(1,i) = decode_char(DecPacket(48+(i-1)*6+1:1:48+i*6));
            end
            
        end
        
        if ismember(registre.format, (5:1:8))
            
            % Altitude
            ra = [DecPacket(49:1:55) DecPacket(57:1:60)];
            registre.altitude = 25*sum(ra .* (2.^(10:-1:0)))-1000;
            
            % timeflag
            registre.timeFlag = DecPacket(61);
            
            % cprFlag
            registre.cprFlag = DecPacket(62);
            
            % Latitude
            
            LAT = sum(DecPacket(63:1:79) .* (2.^(16:-1:0)));
            Dlat = 360/(60 - registre.cprFlag);
            j = floor(refLat/Dlat) + floor(0.5 + mod(refLat, Dlat)/Dlat - LAT/(2^17));
            
            registre.latitude = Dlat * (j + LAT/(2^17));
            
            
            % Longitude
            LON = sum(DecPacket(80:1:96) .* (2.^(16:-1:0)));
            
            Dlon = 360;
            NL_i = cprNL(registre.latitude) - registre.cprFlag;
            if NL_i > 0
                Dlon = 360/NL_i;
            end
            m = floor(refLon/Dlon) + floor(0.5+mod(refLon, Dlon)/Dlon - LON/(2^17));
            
            registre.longitude = Dlon * (m + LON/(2^17));
            
            
            
        end
        
    end
end