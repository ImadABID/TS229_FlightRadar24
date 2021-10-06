function registre = bit2registre(vect_bin)
    registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[]);
    
    DF = bi2de(vect_bin(1:5));
    registre.format = DF;
    
    AA = bi2de(vect_bin(9:32));
    registre.adresse = AA;
    
    FTC = bi2de(vect_bin(33:37));
    registre.type = FTC;
    
    if FTC <= 4        
        name = "";
        index = 40;
        for k=1:8
            for num=1:16
                num = num - 1;
                if num == bi2de(vect_bin(index:index+5))
                    
            
        end
        registre.nom =
    end
    if FTC > 8 && FTC <= 22 && FTC ~= 19
        alt = bi2de(vect_bin(41:52));
        registre.altitude = alt;

        UTC = bi2de(vect_bin(53));
        registre.timeFlag = UTC;

        CPR = bi2de(vect_bin(54));
        registre.cprFlag = CPR;

        lat = bi2de(vect_bin(55:71));
        registre.latitude = lat;

        long = bi2de(vect_bin(72:87));
        registre.longitude = long;
     end
    

end