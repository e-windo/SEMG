%Experimental script for analysing AR models 

%Compute LPC coefficients + predictions
[d,p] = lpc(X,50);
xh = filter(-d(2:end),1,X);
%{
figure
hold on;
plot(temp)
plot(xh)
%}

%Contrast periodogram to AR prediction
figure;
periodogram(X);
hold on;
[H,w] = freqz(sqrt(p),d);
hp = plot(w/pi,20*log10(2*abs(H)/(2*pi)),'r'); % Scale to make one-sided PSD
hp.LineWidth = 2;

%Compute residuals and sum of squared error
delta = X-xh;
sse = delta'*delta;
figure;
plot(X,'b');
hold on;
plot(delta,'r');

%Test for correlation in residuals with Ljung-Box test
[h,pValue] = lbqtest(delta,floor(10.^(0:0.5:floor(log10(length(X)-1)))));