
function [dn_Tx, dn_w] = dn_Thresh(org_data, type, f_sample)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a Denoising/Detection code about soft threshold baesd on SSWT
% 
% [Input parameters]:
% org_data £º original data
% type :   denoing method you select, 'hard' , 'soft' , 'bandpass' 
% f_sample:  data sample
% 
% [Output parameters]:
% dn_Tx: Time-frequency spetrum after denoing
% dn_w:  data waveform after denoing
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
    for i = 1 : nx
%         Wx_fine = abs(org_wsst_Tx(i, 1:noise_tt));
        Wx_fine = abs(org_wsst_Tx(i, :));
        lamda = sqrt( 2 * log(ny) ) * mad( abs(Wx_fine (:))) * 1.4826; % hard  threshold
%                   lamda = sqrt( 2 * log(nx) ) * median( abs(Wx_fine(:) - median(Wx_fine(:)))) * 1.4826; %
        val = org_wsst_Tx(i,:);
        switch type
            case 'soft'
            res = abs(val) - lamda;
            res = (res + abs(res))/2;
            dn_val = sign(val).*res;
            case 'hard'
              dn_val = val.*(abs(val) > lamda);                            
        end
        dn_Tx(i,:) = dn_val;
    end
    
    dn_w = iwsst(dn_Tx, f, [f(1), f(end)]); 
    

    
    
    
    