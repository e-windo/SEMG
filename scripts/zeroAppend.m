function data = zeroAppend(data,nZeroes)
assert(isvector(data),'Needs to be a vector')
if (isrow(data))
    data = [data, zeros(size(data,1),nZeroes)];
else
    data = [data; zeros(nZeroes,size(data,2))];
end