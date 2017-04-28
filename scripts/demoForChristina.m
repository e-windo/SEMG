%load('sensor');
close all;

i = 10;
Fs = 2000;
Rs = 2000;
X = sensor{1:end,i};
X = resample(X,Rs,Fs);

t = (1:length(X))./Rs;

plot(t,X);
title(sensor.Properties.VariableNames{i});

figure;
aNiceFSpectrum(t',X,Rs);
%aNiceFSpectrum(t',X-mean(X),Rs);