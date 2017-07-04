function y = maxFilter(x,N)
%Max filter of order N

if iscolumn(x)
   x = x';
   col = true;
else
   col = false; 
end

y = zeros(size(x));
x = [x, -Inf*ones(1,N)];

for i = 1:length(y)
    if i < N+1
        y(i) = max(x(1:i));
    else
       y(i) = max(x(i-N+1:i)); 
    end
end
y = ternary(col,y',y);
y = y + eps;
end