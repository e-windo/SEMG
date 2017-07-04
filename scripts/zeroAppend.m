function data = zeroAppend(data,nZeros)
%Appends nZeroes of zeros to the data
if (isrow(data))
    data = [data, zeros(size(data,1),nZeros)];
else
    data = [data; zeros(nZeros,size(data,2))];
end