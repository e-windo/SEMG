function displayPrettyActivationSchedule(t,data,ids,ulim,hlim)
set(0,'DefaultTextInterpreter','none');
nDisplay = length(ids);
%ulim = 0.45*10^6;
%hlim = 3*10^6; %0.5*10^6;
ax = cell(1,nDisplay);
for i = 1:nDisplay
   ax{i} = subplot(nDisplay,1,i);
   currData = data{ulim:hlim,ids(i)};
   labels = discriminateMuscleActivity(predictMuscleActivity(currData));
   plot(t(ulim:hlim),currData,'r');
   hold on;
   plot(t(ulim:hlim),labels.*currData,'b');
   title(data.Properties.VariableNames{ids(i)});
   ylabel('Contraction? True/False');
end
xlabel('Time /s');
cat = [];
for i = 1:nDisplay
    cat = [cat,ax{i}];
end

linkaxes(cat,'xy');

end