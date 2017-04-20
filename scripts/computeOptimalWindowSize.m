function L = computeOptimalWindowSize(data,fs)
%This doesn't work very well...
deriv = diff(data)*fs;
g = 234.5;
L = fs*(1/(g^(1/3)))*(mean(data.^2)/(mean(deriv.^2))^(1/3));
end