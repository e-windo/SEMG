function out = getSimilarity(A,b)
N = length(A);
dist = zeros(1,N);
for i = 1:length(A)
    
    temp = A(i,:);
    distance = temp*b'/sqrt((temp*temp')*(b*b')); %L1
    dist(i) = distance;
    
end
out = dist;
end