function [data_filter]=one_dim_filter_bp(dt,data,low_f,high_f,filter_type)
%%  the time dimension must be the odd number;
%%% [data_filter,a1,f,filter]=one_dim_filter(dt,data,low_f,high_f,filter_type)
%%% Updated on Dec 10, 2016 to change the original code to bandpass filter;
%%% filter_type: 1->bandpass; 9->recover low-f plus bandpass

if size(data,1)==1
    data=data';
end

if low_f >= high_f
    fprintf('The low_f should larger than high_f! \n');
    return;
end
NN=size(data,1);

% t=0:dt:(NN-1)*dt;
% f=(-(NN-1)/2:(NN-1)/2)/NN/dt;

F_data=fft(data,[],1);

% n=48; %%% the bigger the sharper
n=5; %%% the bigger the sharper

a1=(0:(NN-1)/2)/NN/dt;%

%% inverse filter
if  abs(filter_type-9)<1e-8  %
    filter1=geophone_response(a1);%% inverse filter (theoretical)
    filter2=fliplr(filter1(2:(NN-1)/2+1));  %
    Inv_filter=horzcat(filter1,filter2);  %% calculate the inverse filter
end

%% low-pass (high-cut) filter
    filter1 = (1+(a1./high_f).^(2*n)).^-1;
    filter2 = fliplr(filter1(2:(NN-1)/2+1));
    filter_low = horzcat(filter1,filter2);
%% high-pass (low-cut) filter
    filter1=(1+(a1./low_f).^(2*n)).^-1;
    filter2=fliplr(filter1(2:(NN-1)/2+1));
    filter_high=1-horzcat(filter1,filter2);


if  abs(filter_type-9)<1e-8
    FF_data=(F_data).*(filter_low').*(filter_high').*(Inv_filter');
else
    FF_data=(F_data).*(filter_low').*(filter_high');
end
data_filter=ifft(FF_data,[],1);
data_filter=real(data_filter);

