function [output] = Two_D_filter_bp(input,dt,low_f,high_f,filter_type)
%% input must be a 2D matrix with odd number in row direction

Nx=size(input,2);
Nt=size(input,1);
size_no=0;
if mod(Nt,2)<.1
    input=[input(1:Nt,:);input(Nt,:)];
    Nt=Nt+1;
    size_no=1;
end
% envelope=0;

length_damp = round(Nt/100)+1;
% length_damp=round(Nz/10)+1;
[damp_bdry] = taper_damp(Nt,length_damp);
output = zeros(size(input));
for ii=1:Nx
%     [output(:,ii),a1,f,filter]=one_dim_filter(dt,input(:,ii).*damp_bdry',low_f,filter_type);
%     [temp,~] = one_dim_filter(dt,input(:,ii),low_f,filter_type);
    temp=one_dim_filter_bp(dt,input(:,ii),low_f,high_f,filter_type);
%     output(:,ii)=temp.*damp_bdry';
    output(:,ii)=temp;
end

if size_no==1
    output=output(1:Nt-1,:);
end
