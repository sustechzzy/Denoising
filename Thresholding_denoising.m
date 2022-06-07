function [dn] = Thresholding_denoising(data, opt)
%% loading data and parameters
dataorg = data.org;
org_s = rmmissing(dataorg);  % 
s = org_s./max(abs(org_s));  %  normalizing waveform
dn.org_noisy = s;
id = length(s);
dt = opt.dt;
nrs = opt.nrs;
f_s = opt.f_s;
f_e = opt.f_e;
nnum = opt.nnum;
bwconn = opt.bwconn;
ECDF_threshold = opt.ecdf_thre;
%%
[Tx, f]= wsst(s, 1/dt);  % Time-frequency spectrum based on SS-CWT.
dn.org_Tx = Tx;
dn.org_f = f ;

%% Finding the range of pure background noise based on the ratio of variance (ROV)
noise  = zeros(1, id);
start_s = floor(id / nrs);
end_s = start_s;

for i = start_s + 1: id - end_s
    noise(i) = var(s(1:i)) / var(s(i:end));
    [~,noise_t] = min(noise(start_s + 1: end - end_s));
    noise_tt  = noise_t + start_s + 1;  % The range of pure background noise£º 0~ noise_tt
end

dn.rov = noise; % saving the ROV curve
%% Finding the frequency range of filtering
[~, fi1] = min(abs(f_s - f));
[~, fi2] = min(abs(f_e - f));
%%  The denoising method based on CDF thresholding
f_x = zeros(size(Tx, 1), size(Tx, 2));
thres = zeros(size(Tx, 1), 1);
for i = fi1 : 1 : fi2
    scal = Tx(i,:);
    x = abs(scal);
    y = sort(x);
    len = id;
    ii = floor(id * nnum);  %
    x1 = x(1: noise_tt);
    [ecdf_f, xx] = ecdf(x1);
    ii = find(ecdf_f >= ECDF_threshold);
    thre = xx(min(ii));
    thres(i) = thre;
    x(find(abs(x) < thre)) = 0;
    x(find(abs(x) >= thre)) = 1;
    
    f_x(i,:) = x;
end
dn.nr = noise_tt;
dn.thres = thres; % saving wavelet coefficient threshold for each frequency
Tx1 = Tx.*f_x;
s_0 = iwsst(Tx1, f, [f(1), f(end)]); % denoising waveform after hard thresholding based on ECDF threshold
dn.ecdf_tf = Tx1; % saving denoising time-frequency spectrum after hard thresholding based on ECDF threshold
dn.ecdf_dw = s_0; % saving denoising waveform  after hard thresholding based on ECDF threshold
%% The time-spectrum image is transformed into a binary image (0 or 1), 
% then, determining the connected component and calculating the area of each component,
% and finally the threshold is set to delete the small area object.
Tx_2 = abs(Tx1);
Tx_2( (Tx_2 > 0)) = 1 ; % Converting the image of time-frequency spectrum to the binary image (0 or 1)
cc = bwconncomp(Tx_2, bwconn);  % Set the connected parameter (4 or 8) and determine the connected components.
S = regionprops(cc, 'Area'); % Calculate the area of each component
for i = 1: length(S)
    st(i) = S(i).Area;  % area of pixel connectivity
end
s_thre = sqrt(2*log(length(st)))*mad(st)/0.6748;

L = labelmatrix(cc);
BW2 = ismember(L, find([S.Area] >= s_thre));
w1 = find([S.Area] >= s_thre);
for k = 1: length(w1)
    ww(k) = (S(w1(k)).Area/max(st) + 0.01);
end
L2 = zeros(size(L));
for ii = 1:length(w1)
    L2 = L2 + ismember(double(L) , w1(ii)).*ww(ii);
end
dn_Tx = Tx1.* BW2.*L2; % Final denoising time-frequency spectrum
s_1 = iwsst(dn_Tx, f, [f(1), f(end)]); % Final denoising waveform
%%%%%%%%%%%%%%%
dn.Tx2map = Tx_2; % Saving the binary image
dn.dtf = dn_Tx; % Saving the final denoising time-frequency spectrum
dn.dw = s_1; % Saving the Final denoising waveform
dn.all_noise = s - dn.dw; % Saving the Final denoised noise
dn.all_noise_Tx = abs(dn.org_Tx) - abs(dn.ecdf_tf);  % Saving the Final denoised time-frequency spectrum of noise

