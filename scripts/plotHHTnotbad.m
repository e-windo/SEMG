function plotHHTnotbad(x,fs)
%Plots the HHT of a given input x

Ts = 1/fs;
[b,g] = sgolay(3,41);

% Get HHT.
N = length(x);
[imf,~,~,~] = SWEMD_LS(x,[],[],[],[],[],[],[]);
        
for k = 1:size(imf,2)
   th{k}   = angle(hilbert(imf(:,k)));
   a{k} = abs(hilbert(imf(:,k)));
   d{k} = conv(unwrap(th{k}),factorial(1)/(Ts)^1 * g(:,2),'same');
   %d{k} = unwrap(diff(th{k})/Ts/(2*pi));
end
nQuant = N-1;
M = zeros(N-1,N-1);
for k = 1:size(imf,2)
    p = imquantize(d{k}+N/2,1:N);
    for i = 1:N-1
        M(p(i),i) = M(p(i),i)+a{k}(i);
    end
end
figure;
s=surf(M(4500:5500,:));
s.EdgeColor = 'none';
xlabel('Time /Samples');
ylabel('Frequency / Hz');

end