clc,clear,close all;

% Message signal parameters
Am = 2; % Peak Amplitude
fm = 10; % Frequency (Hz)
fs = 100; % Sampling Frequency (Hz)
fc = 25; % Carrier Frequency (Hz)
T = 50; % Total Time (s)
t = 0:1/fs:T; % Time Vector

m = Am*sin(2*pi*fm*t); % Generating Message Signal
s = amDSBSC(m, fc, fs); % Modulated Message signal Using DSB-SC
s = s';


% Generating a noise vector with the same dimensions as the message signal.
% To generate a white Gaussian noise signal with power 0 dBW, we used the following code:

% power (dBW)
P_dBW = 0;

P = 10^(P_dBW/10);

n = sqrt(P/2) * randn(size(m));

% Received signal (x)
x = s + n;

% We calculated pre-detection SNR
predetection_SNR = 10*log10(mean(s.^2)/mean(n.^2));

% We set the message signal amplitude to obtain desired SNR
while predetection_SNR < 9.9999999
    Am = Am + 0.0001; % Increasing message signal amplitude
    m = Am*sin(2*pi*fm*t); % Updated message signal
    s = amDSBSC(m, fc, fs); % Updated modulated signal
    predetection_SNR = 10*log10(var(s)/var(n)); % Updated SNR
end

fprintf('Peak Amplitude of the Message Signal (Am): %.2f \n', Am);
fprintf('Pre-Detection SNR: %.2f dB\n', predetection_SNR);

figure(1)
f = gcf;
f.Color = [0.7 0.8 0.9];
hold on
plot(t,m,'--r')
plot(t,s,'k')
plot(t,x,':b')
xlim([0 2])
grid on
xlabel ('Time','fontsize',10), ylabel('Amplitude','fontsize',10)
legend ('Message Signal','Modulated Signal','Received Signal')
title ('Message-Modulated Signal and Received Signal')


% We calculated the demodulated recevied signal
z = amCoDet(x,fc,fs);

% We calculated post-detection SNR
postdetection_SNR = 10*log10(mean(z.^2)/mean(n.^2));

figure(2)
f = gcf;
f.Color = [0.7 0.8 0.9];
hold on
plot(t,m,'--r')
plot(t,z,'b')
xlim([0 2])
grid on
xlabel ('Time','fontsize',10), ylabel('Amplitude','fontsize',10)
legend ('Message Signal','Demodulated Received Signal')
title ('Message Signal and Demodulated Received Signal')

