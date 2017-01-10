function spectrum = getWaveletPower(C,L)
if iscolumn(C)
    C = C';
    L = L';
end
spectrum = zeros(size(L)-1);
CS = [0,cumsum(L)];
for i = 1:length(L)-1
    temp = C(CS(i)+1:CS(i+1));
    spectrum(i) = temp*temp';
end
end