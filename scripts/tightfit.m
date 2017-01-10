function tightfit(i,N,mode)
offset = N;
if strcmp(mode,'v')
    pos = [0,1-(i)/offset,1,1/(offset+1)];
else
    pos = [(i-1)/offset 0 1/(offset+1) 1];
end
set(gca,'position',pos,'units','normalized');
end