function Y = sgolayImpl(order,data,step)

N = length(data);
FLIP = iscolumn(data);
if (FLIP)
    data = data';
end
PAD = mod(N,step);
N = N+PAD;
data = [data,zeros(1,PAD)];
assert(mod(step,2)==1,'Step must be odd');
X = -floor(step/2):floor(step/2);
J = zeros(step,order+1);
Y = zeros(size(data));
for i = 0:order
    J(:,i+1) = X.^i;
end

nSteps = floor(N/step);

C = (J'*J)\J';

for i = 1:nSteps
    idx = step*(i-1);
    Y(1+idx:step+idx) = J*C*data(1+idx:step+idx)';
end

Y = Y(1:end-PAD);
if (FLIP)
    Y = Y';
end
end