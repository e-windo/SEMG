%Experimental morphops work

figure;
for j = 1:13
    figure;
    dat =sensor{round(2000*127.53):round(2000*132.69),j};
    nSplit = 4;
    temp = [];
    subplot(211)
    for i = 1:nSplit
        %ax{i} = subplot(nSplit,1,i);
        
        temp{i} = dat(round(1+(i-1)*length(dat)/nSplit):round(i*length(dat)/nSplit));
        labels{i} = activityDetHMM(temp{i},4,[],[]);
        %
        plot(temp{i},'DisplayName',['Repeat ',num2str(i)]);
        title(sensor.Properties.VariableNames{j});
        hold on;
    end
    subplot(212)
    
    legend('-DynamicLegend');
    for i= 1:nSplit
        for k = 1:nSplit
            %results(i,k) = dtw(maFilter(labels{i},150),maFilter(labels{k},150));
        end
    end
    subplot(212);
    q = zeros(size(temp{1}));
    for i = 1:nSplit
        q = q + temp{i}(1:length(q));
        
    end
    q = q./nSplit;
    labelsQ = activityDetHMM(q,4,[],[]);
    stem(morphOps(labelsQ));
    %}
    %title(num2str(j));
    %{
aq = [];
for i = 1:8
    aq = [aq,ax{i}];
end
linkaxes(aq,'x');
    %}
end
