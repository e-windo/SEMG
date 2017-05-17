function out = demoWignerVille(sensor,t)
ulim = 0.470*10^6;
hlim = 0.480*10^6;
qDat = sensor{ulim:hlim,1};
tDat = t(ulim:hlim);

[tfr, t, f] = wv(resample(qDat'./max(qDat'),1000,2000));
contour(f,t,abs(tfr'));

out = 0;
end