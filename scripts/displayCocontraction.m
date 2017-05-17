function displayCocontraction(t,data,ids,ref)
set(0,'DefaultTextInterpreter','none');
nDisplay = length(ids);
ulim = 1;%0.45*10^6;
hlim = height(data);%0.5*10^6;
ax = cell(1,nDisplay);
labels = cell(1,nDisplay);

refData = data{ulim:hlim,ref};
refLabels = discriminateMuscleActivity(predictMuscleActivity(refData));
   
   
for i = 1:nDisplay
   ax{i} = subplot(nDisplay,1,i);
   currData = data{ulim:hlim,ids(i)};
   labels{i} = discriminateMuscleActivity(predictMuscleActivity(currData));
   plot(t(ulim:hlim),labels{i},'r');
   hold on;
   %area(t(ulim:hlim),labels{i}.*refLabels);% plot(t(ulim:hlim),labels{i}.*refLabels,'b');
   title(data.Properties.VariableNames{ids(i)});
   sprintf('%s , %d',data.Properties.VariableNames{ids(i)},sum(labels{i}.*(1-refLabels)))
   ylabel('Contraction? True/False');
end
xlabel('Time /s');
cat = [];
for i = 1:nDisplay
    cat = [cat,ax{i}];
end

linkaxes(cat,'xy');

end