function out = rmsFilter(input, N)
temp =  reshape(input,N,[]);
out = rms(temp);