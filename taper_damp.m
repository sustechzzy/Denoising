function [damp_bdry]=taper_damp(NN,length_damp)

temp_R=cos(2*pi*(1/2/(length_damp-1))*(0:length_damp-1))/2+.5;
temp_L=fliplr(temp_R);
damp_bdry=[temp_L ones(1,NN-2*length_damp) temp_R];


% plot(damp_bdry,'o-')
return