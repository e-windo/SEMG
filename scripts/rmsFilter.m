function out = rmsFilter(input, N)
if N==1
    out = input;
else
    temp =  reshape(input,N,[]);
    out = rms(temp);
end