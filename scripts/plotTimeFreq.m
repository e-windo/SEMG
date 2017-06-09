function plotTimeFreq(input,Fs)
figure;

subplot(2,2,1);

plot((1:length(input))./Fs,input);
title('Time domain signal');
xlabel(['Time / s, fs = ', num2str(Fs),'Hz']);
ylabel('Amplitude / V');
axis([1/Fs,length(input)/Fs,-sign(min(input))*1.1*min(input),1.1*max(input)]);

subplot(2,2,2);
plot((1:length(input))./Fs,input);
title('Time domain signal');
xlabel(['Time / s, fs = ', num2str(Fs),'Hz']);
ylabel('Amplitude / V');
axis([1/Fs,length(input)/Fs,-sign(min(input))*1.1*min(input),1.1*max(input)]);

ax = subplot(2,2,[3,4]);
aNiceFSpectrum(input-mean(input),Fs,'handle',ax);

%{
hold on;
[d,p] = lpc(input,150);
[H,w] = freqz(p,d);
hp = plot(w*1000/pi,abs(H),'r'); % Scale to make one-sided PSD
%hp.LineWidth = 2;
hp = plot(-w*1000/pi,abs(H),'r'); % Scale to make one-sided PSD
%hp.LineWidth = 2;
%}
end