function teo = getTEO(x,a)
teo = x;
m = 0.5;
for n = 1+a:length(x)-a
    teo(n) = x(n)^2 - x(n-a)*x(n+a);
end
teo(1:a) = 0;
teo(end-a+1:end)=0;
end