function pos = integrateAcc(x,y,z,fs,maOrder)
%Given x,y,z accelerations, find resultant trajectory

%assume start = [0,0,0]
%use simple integration 

x = x - maFilter(x,maOrder);
y = y - maFilter(y,maOrder);
z = z - maFilter(z,maOrder);

pos = zeros(length(x),3);
ts = 1/fs;
for i = 2:length(x)
   pos(1,i) = pos(1,i-1)+x(i)*ts;
   pos(2,i) = pos(2,i-1)+y(i)*ts;
   pos(3,i) = pos(3,i-1)+z(i)*ts;
  %pos(1,i) = wholesomeIntegration(x);
  % pos(2,i) = wholesomeIntegration(y);
  % pos(3,i) = wholesomeIntegration(z);
  
end



end