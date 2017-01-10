function data = zeroAppend(data,powTwo)
assert(isvector(data),'Needs to be a vector')
N = length(data);
nZeroes = 2^powTwo - N;
if (isrow(data))
    data = [data, zeros(size(data,1),nZeroes)];
else
    data = [data; zeros(nZeroes,size(data,2))];
end