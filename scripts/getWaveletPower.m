function [spectrum,split] = getWaveletPower(C,L)
if iscolumn(C)
    C = C';
    L = L';
end
spectrum = zeros(size(L)-1);
CS = [0,cumsum(L)];
split = zeros(length(L)-1,CS(end-1));
for i = 1:length(L)-1
    temp = C(CS(i)+1:CS(i+1));
    spectrum(i) = temp*temp';
    split(i,:) = zeroAppend(temp,CS(end-1)-length(temp));
end
end