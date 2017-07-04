function N = getNEpochs(data,fs,duration,overlap,discard)
%Computes the number of epochs obtainable from given data
%Input:
% data, input data
% fs, sampling frequency of data
% duration, duration in s of epoch
% overlap, overlap between epochs
% discard, discard data that does not fit nicely into epochs or zero pad it
%Output:
% N, number of possible epochs
if ((overlap > 0.95) || (overlap < 0)) %0.95 is a rough limit, as data quickly becomes Big
    error('Unsupported feature: Overlap has to be between 0 and 0.7');
end
%Finds the number of samples in the data
nSamp = size(data,1);
%Finds the number of samples in each subblock
M = duration*fs;

%Finds the number of subblocks, allowing for overlap
if (discard == true)
    N = floor(((((nSamp/M)-1)/(1-overlap))+1));
else
    N = max(ceil(((((nSamp/M)-1)/(1-overlap))+1)),1);
end
end