%% Init
clc;
clear all;
close all;

addpath("../../data/");
addpath("../MAC/");
addpath("../General/");

adsb_msgs = load("adsb_msgs.mat");

adsb_msgs = (adsb_msgs.adsb_msgs)';
[nbr_msg, ~] = size(adsb_msgs);

LON = zeros(1, nbr_msg);
LAT = zeros(1, nbr_msg);

j = 1;
for i=1:1:nbr_msg
    info_registre = bit2registre(adsb_msgs(i,:), -0.6055, 44.8066);
    if isfield(info_registre, "longitude")
        LON(j) = info_registre.longitude;
        LAT(j) = info_registre.latitude;
        j = j+1;
    end
end

LON = LON(1:j-1);
LAT = LAT(1:j-1);

affiche_carte(LON, LAT);

