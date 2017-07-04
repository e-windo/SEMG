%Experimental template detection

data = partitionedData{1}{1};
N = 3;
figure;
gap = 4000;
%{
template = cell(1,N);

for i = 1:N
    template{i} = maFilter((activityDetHMM(data{2*gap+1:3*gap,i},4,[],[])),10);
end
%}
for i = 1:3
    subplot(N,1,i);
    procDat = maFilter((activityDetHMM(data{:,i},4,[],[])),10);
    plot(conv(templateDetache{2},procDat));
    title(muscleNames{i});
    axis('tight');
end

xlabel('Samples /N')