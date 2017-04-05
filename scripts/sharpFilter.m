function out = sharpFilter(data,N)
    out = data - maFilter(data,N);
end