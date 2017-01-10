function data = maFilter(data,N)
data = filter(ones(1,N)./N,[1],data);