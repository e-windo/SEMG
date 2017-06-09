%Use 'Run_number_34_Plot_and_Store_Bach_and_Scale_repetitions_Rep_1.15.hpf';

subplot(131)
plot(sensor{769590:769960,8})
ylabel('Amplitude/ V')
xlabel('Samples / N, fs = 2KHz')
title('MUAP, raw EMG data');

subplot(132)
nRMS = 32;
temp = rmsFilter(sensor{:,8},nRMS);
plot(temp(round((769590/32:769960/nRMS))))
ylabel('Amplitude/ V')
xlabel(['Samples / N, fs = ',num2str(2000/nRMS),'Hz'])
title('MUAP, rms filtered EMG data');

subplot(133);
%plot(mexihat(-5,5,300).*(0.0+randn(1,300)));
temp = simulateSEMG(0,1,0,0,300);
plot(temp(1:300));
%plot(mexihat(-5,5,300).*sin(2*pi*20*(linspace(0,1,300))));
ylabel('Amplitude')
xlabel(['Samples / N, fs = 2000Hz'])
title('Simulated MUAP from Ricker wavelet');