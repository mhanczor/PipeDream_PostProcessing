

close all

odVal0 = csvread([file_path '/od1_0_values.csv'], 2);
odVal0 = odVal0(:,8);
odVal0 = odVal0/100.0;

odVal1 = csvread([file_path '/od1_1_values.csv'], 2);
odVal1 = odVal1(:,8);
odVal1 = odVal1/100.0;

Fs = 1000;
t0 = (0:length(odVal0) - 1)/Fs;
t1 = (0:length(odVal0) - 1)/Fs;

start = 1;

figure
hold on
% scatter(t0, odVal0, '.')
% scatter(start:length(odVal1)+start - 1, odVal1, '.')


lb = 1/6;
ub = 1/20;

d0 = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',lb,'HalfPowerFrequency2',ub, ...
               'DesignMethod','butter','SampleRate',Fs);
           
bF0 = filtfilt(d0,odVal0);
plot(t0, odVal0, t0, bF0);

% figure
% [popen,fopen] = periodogram(odVal0,[],[],Fs);
% [pbutt,fbutt] = periodogram(bF0,[],[],Fs);
% 
% plot(fopen,20*log10(abs(popen)),fbutt,20*log10(abs(pbutt)),'--')
% ylabel('Power/frequency (dB/Hz)')
% xlabel('Frequency (Hz)')
% title('Power Spectrum')
% legend('Unfiltered','Filtered')
% grid