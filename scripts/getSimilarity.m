function out = getSimilarity(A,b)
%Computes the similarity of b to every row of A, in terms of correlation
N = length(A);
dist = zeros(1,N);
for i = 1:length(A)
    
    temp = A(i,:);
    distance = temp*b'/sqrt((temp*temp')*(b*b')); %L2
    dist(i) = distance;
    
end
out = dist;
end