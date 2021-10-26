function [] = affiche_carte(REF_LON, REF_LAT)
    % Plot trajectoire + logo avion
    STYLES = {'-','--',':'};
    STYLES_HEAD = {'x','o','<'};
    COLORS = lines(6);
    COLORS(4,:)=[];

    figure(1);
    hold on;

    %Bdx
    xmax = 0.7128;
    xmin = -1.3581;
    ymax = 45.1683;
    ymin = 44.4542;
    
    x = linspace(xmin, xmax,1024);
    y = linspace(ymin, ymax,1024);
    
    %elimanate out of range pts
    REF_LON_inrange = REF_LON;
    REF_LAT_inrange = REF_LAT;
    
    [~, size_l] = size(REF_LON);
    
    j=1;
    for i=1:1:size_l
        if xmin < REF_LON(i) && REF_LON(i) < xmax && ymin < REF_LAT(i) && REF_LAT(i) < ymax
            REF_LON_inrange(j) = REF_LON(i);
            REF_LAT_inrange(j) = REF_LAT(i);
            j = j+1;
        end
        
    end
    
    REF_LON = REF_LON_inrange(1:1:j-1);
    REF_LAT = REF_LAT_inrange(1:1:j-1);
    

    [X,Y] = meshgrid(x,y(end:-1:1));
    im = imread('fond.png');
    image(x,y(end:-1:1),im);
    plot(REF_LON,REF_LAT,'.r','MarkerSize',20);
    %text(REF_LON+0.05,REF_LAT,0,'Actual pos','color','b')
    set(gca,'YDir','normal')
    xlabel('Longitude en degres');
    ylabel('Lattitude en degres');
    zlim([0,4e4]);
    % Bdx
    xlim([-1.3581,0.7128]);
    ylim([44.4542,45.1683]);
end
