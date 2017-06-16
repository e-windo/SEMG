function [labels,hmm,pos] = activityDetHMM(input,order,hmm,pos)

TSubj = length(input);
if isempty(hmm)
if isempty(order)
    order = 4;
end
options = struct();
K = 2;
options.K = K;
options.covtype = 'diag'; % model just variance of the noise
options.order = order; % MAR order
options.zeromean = 1; % model the mean
options.tol = 1e-8;
options.cyc = 25;
options.inittype = 'hmmmar';
options.initcyc = 5;
options.initrep = 3;
options.verbose = 0;
%options.onpower = 1; %Run on POWER. doesn't work though
%options.pca = 0.99;
subj = input';
[hmm, ~, ~, vpathTime, ~, ~, ~] = hmmmar(subj'./mean(subj),TSubj,options);
colours = ['b','r'];
powers = zeros(1,K);
predictedStates = cell(1,K);
%figure;
%hold on;
for j = 1:K
    predictedStates{j} = subj(order+1:end).*(vpathTime==j)';
    powers(j) = std(predictedStates{j})/sum(vpathTime==j);
    predictedStates{j}(predictedStates{j}==0)=NaN;
end
[~,permsTime] = sort(powers);
colours = colours(permsTime);
%{
for j = 1:K
    plot(predictedStates{j},colours(j),'DisplayName',['State ', num2str(j)]);
end
%}
%title('HMMAR, no RMS filter');
%axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
[~,pos] = max(powers);
labels = vpathTime==pos;
else
    vPath = hmmdecode(input,TSubj,hmm,1);
    labels = vPath==pos;
end
end