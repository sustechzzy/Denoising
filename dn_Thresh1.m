function [org_wsst_Tx, f, dn_Tx, dn_w] = dn_Thresh1(org_data, type, f_sample)
% **********************************************************************
% This is a denoising/detection code about hard or soft threshold baesd on SSWT
% Created on Sun Apr 21 2020.
% Author: Zeng Zhiyi at SUSTech.
% **********************************************************************
% [Input parameters]£º
% org_data £º original data.
% type     £º denoisng method you select, 'hard' , 'soft'. 
% f_sample £º data sample rate.
% 
% [Output parameters]:
% org_wsst_Tx: Time-frequency spetrum of original data.
% f          : Frequency distribution with SSWT.
% dn_Tx:     : Time-frequency spetrum after denoisng.
% dn_w:      : Waveforms after denoing.
%% 
[org_wsst_Tx, f]= wsst(org_data, f_sample);
%% Finding the range of pure background noise based on the ratio of variance
id = size(org_wsst_Tx, 2);
noise  = zeros(1, size(org_wsst_Tx, 2));
start_s = floor(id / 10);   
end_s = start_s;
for i = start_s + 1: id - end_s
    noise(i) = var(org_data(1:i)) / var(org_data(i:end));
    [~, noise_t] = min(noise(start_s + 1: end - end_s));
    noise_tt  = noise_t + start_s + 1;  % The range of pure background noise£º 0~ noise_tt
end
%%
[nx, ny] = size(org_wsst_Tx);
f_s = 20;
f_e = 1000;
[~, fi1] = min(abs(f_s - f));
[~, fi2] = min(abs(f_e - f));
for i = 1 : nx
    val = org_wsst_Tx(i,:);
    if i >=fi1 && i<=fi2
%         Wx_fine = abs(org_wsst_Tx(i, 1:noise_tt));
         Wx_fine = abs(val(1:end));
        lamda = sqrt( 2 * log(ny) ) * mad( abs(Wx_fine (:))) * 1.4826; % hard  threshold
%         lamda = sqrt( 2 * log(nx) ) * median( abs(Wx_fine(:) - median(Wx_fine(:)))) * 1.4826; %
        switch type
            case 'soft'
            res = abs(val) - lamda;
            res = (res + abs(res))/2;
            dn_val = sign(val).*res;               
%               dn_val = 1./(1 + exp(-2.5*(abs(val) - lamda)./lamda)).*val;
            case 'hard'
              dn_val = val.*(abs(val) > lamda);                  
        end
        dn_Tx(i,:) = dn_val;
    else
        dn_val = val.*0;
        dn_Tx(i,:) = dn_val;
    end
end
    
dn_w = iwsst(dn_Tx, f, [f(1), f(end)]); 
    
           