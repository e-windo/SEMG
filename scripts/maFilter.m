function data = maFilter(data,N)
%Moving average filter of order N
data = filter(ones(1,N)./N,[1],data);