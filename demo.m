clc
clear 
close all
%%
data.org = load ('data_noise_new7.mat'); % load original data
data.org = data.org.data_noise;
data_e = load('original_synthetic_data.mat');
%%%%%%%%%%%%%%%%%%%%%%%   Parameters input
sample = 6000;  % Sampling rate of seismic record
opt.f_s = 20;   % The cut-off frequency1 
opt.f_e = 3000;  %  The cut-off frequency2 
%%%%%%%%%%%%%%%%%% 
opt.dt = 1/sample; 
% w_len = length(data.org);
opt.nrs = 10;
opt.nnum = 0.7;

[Tx_e, f] = wsst(data_e.data_e,sample);
% t = opt.dt : opt.dt: length(dn.org_noisy)*opt.dt;
%%  input denoising parameters (ECDF threshold)
opt.ecdf_thre = 0.99; % ECDF threshold
opt.bwconn = 8;    %  4 or 8
[dn] = Thresholding_denoising(data, opt);
t = opt.dt : opt.dt: length(dn.org_noisy)*opt.dt;
%%  Hard and soft thresholding
org_data = data.org;
type1 = 'hard';
[dn1.hard_Tx, dn1.hard_dw] = dn_Thresh(org_data, type1, sample);
type2 = 'soft';
[dn1.soft_Tx, dn1.soft_dw] = dn_Thresh(org_data, type2, sample);
%%  Band-pass filtering
input = data.org;
low_f = 150;
high_f = 400;
filter_type = 1;
[bp_dw] = Two_D_filter_bp(input,1/sample,low_f,high_f,filter_type);
[ bp_Tx, bp_f] = wsst(bp_dw, sample);
%%
for i = 1
xmax = 0.4;
cmax = 0.5;
fontsize1 = 15;
fontsize2 = 25;
line_w1 = 1;
line_w2 = 1;
figure(1)
subplot(4,2,1)
plot(t, data_e.data_e, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.1, 1.3, '(a)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);

subplot(4,2,3)
plot(t, dn.org_noisy, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.1, 1.3, '(b)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);

subplot(4,2,5)
plot(t, dn.ecdf_dw./max(abs(dn.ecdf_dw)), 'linewidth', line_w1);
% plot(t, dn1.hard_dw./max(abs(dn1.hard_dw)), 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.1, 1.3, '(c)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);

subplot(4,2,7)
% plot(t, dn.dw./max(abs(dn.dw)), 'linewidth', line_w1);
plot(t, dn.dw./max(abs(dn.dw)), 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [0:0.05:0.4], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.1, 1.3, '(d)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);

map_my = (mymap('coolwarm'));
subplot(422)
pcolor(t, dn.org_f, abs(Tx_e));
shading interp
ylim([0 1000])
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.11, 1150, '(a-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 5,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(Tx_e)))*cmax]);
colorbar('Position',...
    [0.911284726754657 0.767151767151767 0.0111111111111111 0.158004158004158]);

subplot(424)
pcolor(t, dn.org_f, abs(dn.org_Tx));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.11, 1150, '(b-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 5,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(dn.org_Tx)))*cmax]);
colorbar('Position',...
    [0.910243060087991 0.547817047817048 0.0111111111111111 0.158004158004158]);

subplot(426)
pcolor(t, dn.org_f, abs(dn.ecdf_tf));
% pcolor(t, dn.wsst_f, abs(dn1.hard_Tx));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.11, 1150, '(c-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 5,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(dn.ecdf_tf)))*cmax]);
% caxis([0, max(max(abs(dn1.hard_Tx)))*cmax]);
colorbar('Position',...
    [0.910243060087991 0.327817047817048 0.0111111111111111 0.158004158004158]);

subplot(428)
pcolor(t, dn.org_f, abs(dn.dtf));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[0:0.05:0.4], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.11, 1150, '(d-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 5,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(dn.dtf)))*cmax]);
colorbar('Position',...
    [0.910243060087991 0.107817047817048 0.0111111111111111 0.158004158004158]);
end
%%
for i = 1
f2 = figure(2);
subplot(221)
plot(t, data_e.data_e, 'linewidth', line_w1 + 0.5);
hold on;
plot(t, dn.dw, 'r', 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
legend('Sythetic signal', 'Denoised signal','fontname', 'times new roman',...
    'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2,...
    'position',[0.345833335810651 0.794158798220609 0.114999997522682 0.0529905546999924]);
text(-0.1, 1.2, '(a)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);
text(0.03, 0.8, 'Denoised and synthetic', 'fontname', 'times new roman','fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);

subplot(222)
plot(t, dn.all_noise, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-0.4 0.4]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], ...
    'ytick',[-0.4:0.2:0.4],'yticklabel',[-0.4:0.2:0.4], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.1, 0.47, '(b)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);
text(0.0181619937694704, 0.397560975609756, 'Extracted noise', 'fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);


subplot(223)
pcolor(t, dn.org_f, abs(dn.dtf));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[0:0.05:0.4], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.11, 1150, '(c)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(dn.dtf)))*cmax]);

subplot(224)
pcolor(t, dn.org_f, abs(dn.all_noise_Tx));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1, 'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[0:0.05:0.4], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.11, 1150, '(d)', 'fontname', 'times new roman','fontsize', fontsize2,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
colorbar;
caxis([0, max(max(abs(dn.all_noise_Tx)))*cmax]);
% magnify(f2);

    axes('position',[0.153854166666667 0.84976033665436 0.204791666666667 0.14401247401247]);%关键在这句！所画的小图
plot(t, data_e.data_e, 'linewidth', line_w1 + 0.5);
hold on;
plot(t, dn.dw, 'r', 'linewidth', line_w1);
xlim([0.16 0.22]);
ylim([-1 1]);
grid minor;
grid on;
% ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1);
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.01:0.4],'xticklabel', [0:0.01:0.4], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1);
    
% figure(3)
% plot(t, data_e.data_e, 'linewidth', line_w1 + 1);
% hold on;
% plot(t, dn.dw, 'r', 'linewidth', line_w1 + 1);
% xlim([0.15 0.23]);
% ylim([-1 1]);
% grid minor;
% grid on;
% % ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1);
% % xlabel({'Time/s'}, 'fontsize', fontsize1);
% set(gca, 'xtick',[0:0.01:0.4],'xticklabel', [0:0.01:0.4], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
%  'fontsize', fontsize1 + 10, 'linewidth', line_w2 + 1);

end
%%
for i = 1
zoom_xmin = 0.15;
zoom_xmax = 0.23;
f4 = figure(4);
 subplot(3,3,1)
plot(t, data_e.data_e, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(a)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Original synthetic', 'fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
annotation(f4,'textbox',...
    [0.217927083333333 0.710992907801418 0.0393645833333334 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);
 
subplot(3,3,3)
plot(t, data_e.data_e, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[zoom_xmin:0.01:zoom_xmax],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(zoom_xmax - 0.111, 1.3, '(a-3)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Zoomed window', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);

subplot(3,3,4)
plot(t, dn.org_noisy, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(b)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Noisy synthetic', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);
annotation(f4,'textbox',...
     [0.217145833333333 0.410840932117528 0.0393645833333333 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);

subplot(3,3,6)
plot(t, dn.org_noisy, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[zoom_xmin:0.01:zoom_xmax],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(zoom_xmax - 0.111, 1.3, '(b-3)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);


subplot(3,3,7)
plot(t, bp_dw, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(c)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Band-pass filterd (200-450Hz)', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);
annotation(f4,'textbox',...
     [0.217145833333333 0.110840932117528 0.0393645833333333 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);

subplot(3,3,9)
plot(t, bp_dw, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1, 'fontweight','bold');
xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[zoom_xmin:0.01:zoom_xmax],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(zoom_xmax - 0.111, 1.3, '(c-3)', 'fontname', 'times new roman','fontsize', fontsize1 + 5,'fontweight','bold', 'linewidth', line_w2);

subplot(3,3,2)
pcolor(t, dn.org_f, abs(Tx_e));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight','bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1, 'fontweight','bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(a-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(Tx_e)))*cmax]);

subplot(3,3,5)
pcolor(t, dn.org_f, abs(dn.org_Tx));
shading interp
ylim([0 1000])
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight','bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(b-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(dn.org_Tx)))*cmax]);

subplot(3,3,8)
pcolor(t, dn.org_f, abs(bp_Tx));
shading interp
ylim([0 1000])
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1, 'fontweight','bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(c-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(bp_Tx)))*cmax]);
end
%%
for i = 1
f5 = figure;
 subplot(3,3,1)
plot(t, dn1.hard_dw, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(d)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Hard thresholding', 'fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
annotation(f5,'textbox',...
    [0.217927083333333 0.710992907801418 0.0393645833333334 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);
 
subplot(3,3,3)
plot(t, dn1.hard_dw, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[zoom_xmin:0.01:zoom_xmax],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(zoom_xmax - 0.111, 1.3, '(d-3)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
% title('Zoomed window', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);

subplot(3,3,4)
plot(t, dn1.soft_dw, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1);
set(gca, 'xtick',[0:0.05:0.4],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(e)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('Soft thresholding', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);
annotation(f5,'textbox',...
     [0.217145833333333 0.410840932117528 0.0393645833333333 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);

subplot(3,3,6)
plot(t, dn1.soft_dw, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[zoom_xmin:0.01:zoom_xmax],'xticklabel', [], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);


subplot(3,3,7)
plot(t, dn.dw, 'linewidth', line_w1);
xlim([0 xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[0:0.1:0.4],'xticklabel', [0:0.1:0.4], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
text(-0.15, 1.3, '(f)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
title('The proposed method', 'fontsize', fontsize1 ,'fontweight','bold', 'linewidth', line_w2);
annotation(f5,'textbox',...
     [0.217145833333333 0.110840932117528 0.0393645833333333 0.204660587639311],...
    'Color',[1 0 0],...
    'LineWidth',2,...
    'LineStyle','--',...
    'FitBoxToText','off',...
    'EdgeColor',[1 0 0]);

subplot(3,3,9)
plot(t, dn.dw, 'linewidth', line_w1);
xlim([zoom_xmin zoom_xmax]);
ylim([-1 1]);
grid minor;
grid on;
ylabel({'Normalized';' amplitude'}, 'fontsize', fontsize1,'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[zoom_xmin:0.02:zoom_xmax],'xticklabel', [zoom_xmin:0.02:zoom_xmax], 'ytick',[-1:0.5:1],'yticklabel',[-1:0.5:1], ...
 'fontsize', fontsize1, 'linewidth', line_w2);

subplot(3,3,2)
pcolor(t, dn.org_f, abs(dn1.hard_Tx));
shading interp;
ylim([0 1000]);
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1,'fontweight', 'bold');
% xlabel({'Time/s'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(d-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(dn1.hard_Tx)))*cmax]);

subplot(3,3,5)
pcolor(t, dn.org_f, abs(dn1.soft_Tx));
shading interp
ylim([0 1000])
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[0:0.05:0.4],'xticklabel',[], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(e-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(dn1.soft_Tx)))*cmax]);

subplot(3,3,8)
pcolor(t, dn.org_f, abs(dn.dtf));
shading interp
ylim([0 1000])
xlim([0 xmax]);
ylabel({'Frequency/Hz'}, 'fontsize', fontsize1,'fontweight', 'bold');
xlabel({'Time/s'}, 'fontsize', fontsize1,'fontweight', 'bold');
set(gca, 'xtick',[0:0.1:0.4],'xticklabel',[0:0.1:0.4], 'ytick',[0:200:1000],'yticklabel',[0:200:1000], ...
 'fontsize', fontsize1, 'linewidth', line_w2);
% text(-0.14, 1150, '(f-2)', 'fontname', 'times new roman','fontsize', fontsize1 + 9,'fontweight','bold', 'linewidth', line_w2);
text(0.3, 800, 'SS-CWT', 'color','w','fontname', 'times new roman','fontsize', fontsize1,'fontweight','bold', 'linewidth', line_w2);
colormap(map_my);
% colorbar;
caxis([0, max(max(abs(dn.dtf)))*cmax]);
end
%%  Comparison of denoising performance (Cross-correlation(CC), SNR, ERMS, Time)
pick = 990;
signal_wlen = 1260;
snr_wlen = signal_wlen - pick;
input_data = [data_e.data_e, data.org, bp_dw, dn1.hard_dw, dn1.soft_dw, dn.dw];
for i = 2: size(input_data, 2)
    if i < 6
    snr(i) = std(input_data(pick: signal_wlen, i))/std(input_data(pick - snr_wlen + 1: pick, i));
    end
    cc = xcorr(input_data(:, i), input_data(:, 1), 'coeff');
    CC(i) = max(cc);
    rms(i) = std(input_data(:, i) - input_data(:, 1));
end
