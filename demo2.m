clc
clear
close all;
%%
load 'original_synthetic_data.mat';
load('data_noise_new7.mat'); % load original noisy data (导入待处理的数据)
data.org = data_noise; 
%%%%%%%%%%%%%%%%%%%%%%%   Parameters input
sample = 6000;  % Sampling rate of seismic record   采样率
% ------------- 下面两个参数是设置滤波范围：
%  1、假如你预先知道有效信号的频带范围，即可设置有效信号的频带范围
%  2、假如你不知道有效信号的频带范围，即可设置输入数据的频带范围（0~ 1/sample/2）
opt.f_s = 20;   % The cut-off frequency1        %  截止频率1
opt.f_e = sample/2;  %  The cut-off frequency2      %  截止频率2
%%%%%%%%%%%%%%%%%% 
opt.dt = 1/sample; 
%   opt.nrs 这个参数是 计算ROV曲线时，  两个时窗是从采样点 （输入数据长度/nrs） 开始 滑动计算。这是为了保证 前面的时窗内含有数据，  
%    opt.num 是在计算 ECDF 阈值化时，因为我们一般设置  ECDF(P >0.95)，为了计算速度快一点，我们直接从 ECDF  > opt.num 以上的数据进行阈值化
opt.nrs = 10;
opt.nnum = 0.7;
%%  input denoising parameters (ECDF threshold)
opt.ecdf_thre = 0.99; % ECDF threshold：ECDF阈值，一般设为 0.95 ~ 0.999
opt.bwconn = 8;    %  4 or 8  :  图像连通性计算规则：4连通或者8连通
%% -------------------  滤波主程序 ---------------------- 
[dn] = Thresholding_denoising(data, opt);
%  dn.org_noisy:   归一化的待滤波的噪音信号
%  dn.org_Tx :     待滤波的噪音信号的时频谱
%  dn.org_Tx :     时频变换后频谱的频点分布
%  dn.rov :        Rov曲线
%  dn.nr:          估计得到的背景噪音范围 0 ~ nr* dt (单位为采样点数);
%  dn.thres:       各个频点的小波系数阈值
%  dn.ecdf_tf:     小波系数阈值化后的有效信号的频谱
%  dn.ecdf_dw:     小波系数阈值化后的有效信号波形
%  dn.dtf:         融合图像处理和小波系数阈值化后的有效信号的频谱
%  dn.dw:          融合图像处理和小波系数阈值化后的有效信号波形
%  dn.all_noise:   滤波后的纯噪音波形
%  dn.all_noise_Tx: 滤波后的纯噪音的频谱
%%
t = opt.dt : opt.dt: length(dn.org_noisy)*opt.dt;
[Tx_e, f] = wsst(data_e,sample);  %  无噪音信号的时频变换， Tx_e为小波系数，f为频点分布
%%  
font1 = 15;
map1 = mymap('coolwarm');
figure
subplot 421
plot(t, data_e)
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Amp', 'fontsize', font1, 'fontweight', 'bold');
ylim([-1 1]);
grid on;
set(gca, 'fontsize', font1);

subplot 423
plot(t, dn.org_noisy)
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Amp', 'fontsize', font1, 'fontweight', 'bold');
ylim([-1 1]);
grid on;
set(gca, 'fontsize', font1);

subplot 425
plot(t, dn.dw)
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Amp', 'fontsize', font1, 'fontweight', 'bold');
ylim([-1 1]);
grid on;
set(gca, 'fontsize', font1);


subplot 427
plot(t, dn.all_noise)
xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Amp', 'fontsize', font1, 'fontweight', 'bold');
ylim([-1 1]);
grid on;
set(gca, 'fontsize', font1);

subplot 422
pcolor(t, f, abs(Tx_e));
shading interp;
colormap(map1);
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Freq/Hz', 'fontsize', font1, 'fontweight', 'bold');
grid on;
set(gca, 'tickdir','out','fontsize', font1);

subplot 424
pcolor(t, dn.org_f, abs(dn.org_Tx));
shading interp;
colormap(map1);
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Freq/Hz', 'fontsize', font1, 'fontweight', 'bold');
grid on;
set(gca, 'tickdir','out','fontsize', font1);

subplot 426
pcolor(t, dn.org_f, abs(dn.dtf));
shading interp;
colormap(map1);
% xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Freq/Hz', 'fontsize', font1, 'fontweight', 'bold');
grid on;
set(gca, 'tickdir','out','fontsize', font1);

subplot 428
pcolor(t, dn.org_f, abs(dn.all_noise_Tx));
shading interp;
colormap(map1);
xlabel('Time/s', 'fontsize', font1, 'fontweight', 'bold');
ylabel('Freq/Hz', 'fontsize', font1, 'fontweight', 'bold');
grid on;
set(gca, 'tickdir','out','fontsize', font1);