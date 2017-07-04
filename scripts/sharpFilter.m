function out = sharpFilter(data,N)
%Applies a sharp filter of order N to the data
    out = data - maFilter(data,N);
end