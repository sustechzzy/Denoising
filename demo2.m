clc
clear
close all;
%%
load 'original_synthetic_data.mat';
load('data_noise_new7.mat'); % load original noisy data (��������������)
data.org = data_noise; 
%%%%%%%%%%%%%%%%%%%%%%%   Parameters input
sample = 6000;  % Sampling rate of seismic record   ������
% ------------- �������������������˲���Χ��
%  1��������Ԥ��֪����Ч�źŵ�Ƶ����Χ������������Ч�źŵ�Ƶ����Χ
%  2�������㲻֪����Ч�źŵ�Ƶ����Χ�����������������ݵ�Ƶ����Χ��0~ 1/sample/2��
opt.f_s = 20;   % The cut-off frequency1        %  ��ֹƵ��1
opt.f_e = sample/2;  %  The cut-off frequency2      %  ��ֹƵ��2
%%%%%%%%%%%%%%%%%% 
opt.dt = 1/sample; 
%   opt.nrs ��������� ����ROV����ʱ��  ����ʱ���ǴӲ����� ���������ݳ���/nrs�� ��ʼ �������㡣����Ϊ�˱�֤ ǰ���ʱ���ں������ݣ�  
%    opt.num ���ڼ��� ECDF ��ֵ��ʱ����Ϊ����һ������  ECDF(P >0.95)��Ϊ�˼����ٶȿ�һ�㣬����ֱ�Ӵ� ECDF  > opt.num ���ϵ����ݽ�����ֵ��
opt.nrs = 10;
opt.nnum = 0.7;
%%  input denoising parameters (ECDF threshold)
opt.ecdf_thre = 0.99; % ECDF threshold��ECDF��ֵ��һ����Ϊ 0.95 ~ 0.999
opt.bwconn = 8;    %  4 or 8  :  ͼ����ͨ�Լ������4��ͨ����8��ͨ
%% -------------------  �˲������� ---------------------- 
[dn] = Thresholding_denoising(data, opt);
%  dn.org_noisy:   ��һ���Ĵ��˲��������ź�
%  dn.org_Tx :     ���˲��������źŵ�ʱƵ��
%  dn.org_Tx :     ʱƵ�任��Ƶ�׵�Ƶ��ֲ�
%  dn.rov :        Rov����
%  dn.nr:          ���Ƶõ��ı���������Χ 0 ~ nr* dt (��λΪ��������);
%  dn.thres:       ����Ƶ���С��ϵ����ֵ
%  dn.ecdf_tf:     С��ϵ����ֵ�������Ч�źŵ�Ƶ��
%  dn.ecdf_dw:     С��ϵ����ֵ�������Ч�źŲ���
%  dn.dtf:         �ں�ͼ�����С��ϵ����ֵ�������Ч�źŵ�Ƶ��
%  dn.dw:          �ں�ͼ�����С��ϵ����ֵ�������Ч�źŲ���
%  dn.all_noise:   �˲���Ĵ���������
%  dn.all_noise_Tx: �˲���Ĵ�������Ƶ��
%%
t = opt.dt : opt.dt: length(dn.org_noisy)*opt.dt;
[Tx_e, f] = wsst(data_e,sample);  %  �������źŵ�ʱƵ�任�� Tx_eΪС��ϵ����fΪƵ��ֲ�
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