N = 1000;
nCoefs = 2;
x = randn(N,1);
wIdeal = [0.1,0.3];
d = filter(wIdeal,[1],x)+0.0*randn(N,1);
w = zeros(length(d),nCoefs);
e = zeros(length(d),1);
y = zeros(length(d),1);
buf = d(1:nCoefs,1);
atten = 0.995;
mu = 0.5;
f = @(e,x)(mu*e*x);
for i = nCoefs+1:length(d)
    buf = x(i-nCoefs+1:i);
    y(i) = fliplr(w(i-1,:))*buf;
    e(i) = d(i)-y(i);
    w(i,:) = atten*w(i-1,:)+fliplr(f(e(i),buf)');
end
subplot(3,1,1)
plot(1:length(d),[d]);
subplot(3,1,2)
plot(1:length(d),[y]);
subplot(3,1,3)
plot(1:length(d),[e]);
w(end,:)