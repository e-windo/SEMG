%movingVarianceCalibration

%Peak at 0.7/fsamp*fs
for j = 1:10
fs = 0.5*j;
tStep = 0.01;
tTest = 0:tStep:20;
iter = 3000;
step = 1;
%figure;
%hold on;

f = @(x)(sin(x*(2*pi)*fs));
mnmx = zeros(1,iter);
y = f(tTest);
%plot(tTest,y);

for i = 1:iter
    
    dat = movvar(y,step*i);
    mnmx(i) = max(dat)-min(dat);
   % plot(tTest,dat);
end

[~,mx] = max(mnmx);

ind(j) = fs;
dep(j) = mx*step;
end