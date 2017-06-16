function displayCocontraction(fs,data,ids,ref)
set(0,'DefaultTextInterpreter','none');
nDisplay = length(ids);
ulim = 1;%0.45*10^6;
hlim = round(length(data{1}));%0.5*10^6;
ax = cell(1,nDisplay);
order = 4;
labels = cell(1,nDisplay);
bothLabels = cell(1,nDisplay);
figure;
refData = data{ref}(ulim:hlim);
refLabels = activityDetHMM(refData,order);
   subplot(nDisplay+1,1,1);
   orderDiscard = 1000;
   filtFun = @(x)(maFilter(x,orderDiscard));
   plot(refData);
   
for i = 1:nDisplay
   ax{i} = subplot(nDisplay+1,1,i+1);
   currData = data{ids(i)}(ulim:hlim);
   labels{i} = activityDetHMM(currData,order);
   bothLabels{i} = labels{i}.*refLabels;
   mutual = filtFun(bothLabels{i}.*currData(order+1:end).^2);
   total = max(0.01*mean(refData.^2),filtFun(labels{i}.*currData(order+1:end).^2));
   plot(mutual(orderDiscard:end)./total(orderDiscard:end))
   %area(t(ulim:hlim),labels{i}.*refLabels);% plot(t(ulim:hlim),labels{i}.*refLabels,'b');
   %title(data.Properties.VariableNames{ids(i)});
   %sprintf('%s , %d',data.Properties.VariableNames{ids(i)},sum(labels{i}.*(1-refLabels)))
   ylabel('Contraction? True/False');
end
xlabel('Time /s');
cat = [];
for i = 1:nDisplay
    cat = [cat,ax{i}];
end

linkaxes(cat,'xy');

end