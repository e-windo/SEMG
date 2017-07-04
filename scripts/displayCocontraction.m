function displayCocontraction(data,ids,ref)
%Display cocontraction between given muscles and a reference
%Input:
%  data,cell array of data indexed by muscle
%  ids, indices of given muscles
%  ref, index of reference muscles

set(0,'DefaultTextInterpreter','none');
nDisplay = length(ids);
ulim = 1;
hlim = round(length(data{1}));
ax = cell(1,nDisplay);
labels = cell(1,nDisplay);
bothLabels = cell(1,nDisplay);
figure;
refData = data{ref}(ulim:hlim);

%get active labels on the reference data
order = 4;
refLabels = activityDetHMM(refData,order);
subplot(nDisplay+1,1,1);
orderDiscard = 1000;
filtFun = @(x)(maFilter(x,orderDiscard));
plot(refData);

%For each given muscle
for i = 1:nDisplay
    ax{i} = subplot(nDisplay+1,1,i+1);
    currData = data{ids(i)}(ulim:hlim);
    %get active labels on the given data
    labels{i} = activityDetHMM(currData,order);
    %find intersection of the labels, and find the associated data
    bothLabels{i} = labels{i}.*refLabels;
    mutual = filtFun(bothLabels{i}.*currData(order+1:end).^2);
    total = max(0.01*mean(refData.^2),filtFun(labels{i}.*currData(order+1:end).^2));
    plot(mutual(orderDiscard:end)./total(orderDiscard:end))
    ylabel('Contraction? True/False');
end
xlabel('Time /s');
cat = [];
for i = 1:nDisplay
    cat = [cat,ax{i}];
end

linkaxes(cat,'xy');

end