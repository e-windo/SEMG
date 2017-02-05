function imdf = medFreq(M)
L = length(M);
Y = fft(M);
P2 = abs(Y)/L;
P1 = P2(1:L/2+1);
C = cumsum(P1);
[~,loc] = max(C>C(end)/2);
imdf = P1(loc);
end