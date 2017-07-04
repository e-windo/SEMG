%Experimental peak detection

figure;
set(0,'defaultfigurecolor',[1 1 1])
set(gcf,'Color',[1,1,1])
for i = 1:3
    subplot(3,1,i);
    hold on;
    subj = analysis{i}';
    subj = subj-mean(subj);
    %{
    options = struct();
K = 2;
options.K = K;
options.covtype = 'full'; % model just variance of the noise
order = 4;
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

TSubj = length(subj);
[hmmTime, ~, ~, vpathTime, ~, ~, ~] = hmmmar(subj'./mean(subj),TSubj,options);
colours = ['b','r'];
powers = zeros(1,K);
predictedStates = cell(1,K);
for j = 1:K
    predictedStates{j} = subj(order+1:end).*(vpathTime==j)';
    powers(j) = std(predictedStates{j});
    predictedStates{j}(predictedStates{j}==0)=NaN;
end
[~,permsTime] = sort(powers);
colours = colours(permsTime);
for j = 1:K
    plot(predictedStates{j},colours(j),'DisplayName',['State ', num2str(j)]);
end
    %}
    
    
    temp = sgolayfilt(abs(hilbert(subj)),3,111);
    %temp = zscore(temp);
    sf = 0.2;
    minPKDST = 300;
    [pks,locs] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
    plot(subj);
    hold on;
    stem(locs,pks,'filled');
    
    title(['Event detection applied to class ',num2str(5-i),' signal'])
    xlabel('Samples/N');
    ylabel('Amplitude/V');
    axis([0,length(subj),aNiceAxisLimit(subj)]);
end