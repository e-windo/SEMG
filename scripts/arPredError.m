temp = randn(1,1000);
%sin(2*pi*0.1*(0:0.01:10));
%sensor{1000000:1010000,8}';
%temp = resample(temp,500,2000);
%plot(temp);
[d,p] = lpc(temp,30);
xh = filter(-d(2:end),1,temp);
%{
figure
hold on;
plot(temp)
plot(xh)
%}
%{
figure;
periodogram(temp);
hold on;
[H,w] = freqz(sqrt(p),d);
hp = plot(w/pi,20*log10(2*abs(H)/(2*pi)),'r'); % Scale to make one-sided PSD
hp.LineWidth = 2;
%}
delta = temp-xh;
sse = delta*delta';
%figure;
plot(delta);
[h,pValue] = lbqtest(delta,floor(10.^(0:0.5:floor(log10(length(temp)-1)))))