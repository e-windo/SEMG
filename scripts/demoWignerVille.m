function out = demoWignerVille(input,fs)
[tfr, t, f] = wv(resample(input'./max(input'),1000,2000));
t = (1:length(t)).*(2/fs);
f = (0:length(f)-1).*(800/fs);
contour(t,f,abs(tfr'));
xlabel('Time /s');
ylabel('Frequency / Hz');
out = 0;
end