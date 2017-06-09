function opt = getOptimalOffset(a,b)
%gets the optimal offset of b wrt a
if (isempty(a) || isempty(b))
    opt = 0;
else
    c = zeros(size(a));
    if length(a) < length(b)
        
        b = b(1:length(a));
    else
        
        a = a(1:length(b));
    end
    
    for i = 1:length(a)
        temp = padarray(b,i,0,'pre');
        temp = temp(1:length(a));
        c(i) = dot(a,temp);
    end
    
    [~,opt] = max(c);
    opt = mod(opt,length(a));
end