function displayPrettyActivationSchedule(t,data,ids,ulim,hlim)
%Plot muscle activations for a given set of muscles
%Input:
%  t, time points
%  data, input data as a cell array of muscles
%  ids, indices of muscles to be examined
%  ulim, lower x limit of study
%  hlim, upper x limit of study
set(0,'DefaultTextInterpreter','none');
nDisplay = length(ids);
ax = cell(1,nDisplay);
for i = 1:nDisplay
   ax{i} = subplot(nDisplay,1,i);
   currData = data{ulim:hlim,ids(i)};
   labels = discriminateMuscleActivity(predictMuscleActivity(currData));
   plot(t(ulim:hlim),currData,'r');
   hold on;
   plot(t(ulim:hlim),labels.*currData,'b');
   title(data.Properties.VariableNames{ids(i)});
end
xlabel('Time /s');
cat = [];
for i = 1:nDisplay
    cat = [cat,ax{i}];
end

linkaxes(cat,'xy');

end