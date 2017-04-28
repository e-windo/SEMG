function teo = getTEO(x,a)
teo = x;
m = 0.5;
for n = 1+a:length(x)-a
    teo(n) = x(n)^2 - x(n-a)*x(n+a);
end

end