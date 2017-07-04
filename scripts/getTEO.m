function teo = getTEO(x,a)
%Applies the Teager-Kaiser energy operator to a signal
%Inputs:
% x, the data
% a, the offset to consider

teo = x;
m = 0.5;
for n = 1+a:length(x)-a
    teo(n) = x(n)^2 - x(n-a)*x(n+a);
end
teo(1:a) = 0;
teo(end-a+1:end)=0;
end