function freqs = getMedFreqFramed(X,n)
%Returns the median frequency for each frame of a data signal
%Input: 
% X, input data
% n, number of frames to split data into
%Output:
% freqs, instantaneous median frequency signal

 nSplit = ceil(length(X)/n);
 freqs = zeros(1,nSplit);
 for i = 1:nSplit
     temp = X(round(1+(i-1)*length(X)/nSplit):round(i*length(X)/nSplit));
     freqs(i) = medfreq(temp,2000);
 end
end
