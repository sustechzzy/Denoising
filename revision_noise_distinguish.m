clc
clear
%%   
load 'original_synthetic_data.mat'; % load orginal signal without adding noise
ns = 2400;
data_e = data_e(1:ns);
f_sample = 6000; % sampling rate
dt = 1/f_sample;
% ns = length(data_e); % the number of samples
t = 0: dt: dt * (ns - 1);
[Tx_e, f] = wsst(data_e, 1/dt);  % 同步挤压小波变换得到时频谱 Tx, 及频点分布

%%  Add the noise consisting of random noise, fixed noise and FM noise
w1 = 0.11;
r_noise = w1.*randn(1, ns); % random noise
fixed_w1 = (0.08 + 0.02.*cos(200.*t)).*cos(2*pi*200.*t + cos(230.*t)); % FM noise
fixed_w2 = (0.08 + 0.02.*cos(200.*t)).*cos(2*pi*340.*t + cos(400.*t));% FM noise
fixed_w3 = (0.08 + 0.02.*cos(200.*t)).*cos(2*pi*256.*t + cos(320.*t));% FM noise
fixed_w4 = 0.08.*cos(2*pi.*(80.*t));% Fixed noise
fixed_w5 = 0.08.* cos(2*pi.*(20.*t)); % Fixed noise
fm_noise =  fixed_w1 + fixed_w2  + fixed_w3;
fix_noise =  fixed_w4 + fixed_w5;
noise_all = fm_noise + fix_noise + r_noise;
[Tx_noise, ~] = wsst(noise_all, f_sample);  % SS-CWT
%%   Generate synthetic noise data
noisy_data = data_e + noise_all';
noisy_data = noisy_data./max(abs(noisy_data));   % Normalized
[Tx_noisy, ~] = wsst(noisy_data,1/dt);  % SS-CWT

%%
map1 = mymap('coolwarm');
font1 = 15;
font2 = 30;
figure
subplot(311)
plot(t, data_e)
xlim([0 ns*dt])
ylim([-1 1])
% xlabel('Time/s', 'fontweight','bold','fontsize',font1);
ylabel({'Normalized',' amplitude'}, 'fontweight','bold','fontsize',font1);
set(gca, 'xticklabel', [], 'fontweight','bold','fontsize',font1)
text(-0.05, 1.3, '(a)', 'fontname','times new roman','fontweight','bold','fontsize',font2);
grid minor
grid on

subplot(312)
plot(t, r_noise)
xlim([0 ns*dt])
ylim([-1 1])
% xlabel('Time/s', 'fontweight','bold','fontsize',font1);
ylabel({'Normalized',' amplitude'}, 'fontweight','bold','fontsize',font1);
set(gca, 'xticklabel', [],'fontweight','bold','fontsize',font1)
text(-0.05, 1.3, '(b)', 'fontname','times new roman','fontweight','bold','fontsize',font2);
grid minor
grid on

subplot(313)
plot(t, fm_noise)
xlim([0 ns*dt])
ylim([-1 1])
% xlabel('Time/s', 'fontweight','bold','fontsize',font1);
ylabel({'Normalized',' amplitude'}, 'fontweight','bold','fontsize',font1);
set(gca, 'xticklabel', [],'fontweight','bold','fontsize',font1)
text(-0.05, 1.3, '(c)', 'fontname','times new roman','fontweight','bold','fontsize',font2);
grid minor
grid on

figure
subplot(211)
plot(t, fix_noise)
xlim([0 ns*dt])
ylim([-1 1])
% xlabel('Time/s', 'fontweight','bold','fontsize',font1);
ylabel({'Normalized',' amplitude'}, 'fontweight','bold','fontsize',font1);
set(gca,'xticklabel', [], 'fontweight','bold','fontsize',font1)
text(-0.05, 1.3, '(d)', 'fontname','times new roman','fontweight','bold','fontsize',font2);
grid minor
grid on


subplot(212)
plot(t, noisy_data)
xlim([0 ns*dt])
ylim([-1 1])
xlabel('Time/s', 'fontweight','bold','fontsize',font1);
ylabel({'Normalized',' amplitude'}, 'fontweight','bold','fontsize',font1);
set(gca, 'fontweight','bold','fontsize',font1)
% title('Synthetic signal','fontweight','bold','fontweight','bold','fontsize',font1)
text(-0.05, 1.3, '(e)', 'fontname','times new roman','fontweight','bold','fontsize',font2);
grid minor
grid on