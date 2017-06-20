function plotMuscleChain(data,ids,nSplit,labels,morphParams)
a = figure;
b = figure;
for i= 1:length(ids)
    temp = cell(1,nSplit);
    figure(a);
    subplot(length(ids),1,i);
    hold on;
    for j = 1:nSplit
        temp{j} = data{round(1+(j-1)*height(data)/nSplit):round(j*height(data)/nSplit),ids(i)};
        
        plot(maFilter(abs(temp{j}),100));
    end
    q = zeros(size(temp{1}));
    for j = 1:nSplit
        q = q + temp{j}(1:length(q));
        
    end
    q = q./nSplit;
    labelsQ = activityDetHMM(q,4,[],[]);
    %set(get(gca,'YLabel'),'Rotation',0)
    %set(gca, 'YTick', []);
    ylabel('Amplitude /V');
    xlabel('Samples /N');
    title(labels{ids(i)});
    figure(b);
    subplot(length(ids),1,i);
    %stem(morphOps(activityDetHMM(temp{4},4,[],[]),'erodeSpan',morphParams(i),'dilateSpan',morphParams(i)));
    ylabel(labels{ids(i)});
    %set(get(gca,'YLabel'),'Rotation',0)
    set(gca, 'YTick', []);
    
end

xlabel('Samples / N');
end