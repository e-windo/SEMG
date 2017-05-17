function out = rmsFilter(input, N)
if N==1
    out = input;
else
    offset = mod(length(input),N);
    if offset ~= 0
        input = zeroAppend(input,N-offset);
    end
end
    temp =  reshape(input,N,[]);
    out = rms(temp);
end