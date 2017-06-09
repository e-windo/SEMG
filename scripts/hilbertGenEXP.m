%Unsuccessful attempt to simulate MUAP

t = linspace(-1,1,300);
N = normpdf(t,0,0.2);
M = sin(2*pi*t*6);
A = N.*M;

%P = sgolayfilt(1*randn(size(A)).*poissrnd(0.05,size(A)),2,3);
Q = [0.0002    0.2968   -1.9542];
P = polyval(Q,1:length(A));


Z = A.*exp(10*P*sqrt(-1));
figure;
subplot(211)
plot(real(Z));
subplot(212)
plot(P);