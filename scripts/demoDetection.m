%demoDetection
results = cell(1,6);
%subj = sensor{1000000:1100000,index}';
subj = analysis{3}';
%subj = 10^6*sgolayfilt(abs(hilbert(subj)),3,411);
%[subj,active,~] = simulateSEMG(1.1,50,0,0,300);
knownActive = false;
%subj = subj + mean(subj)*randn(size(subj))*0.1;
subj = subj-mean(subj);
sfFixed = 2;
nRMS = 40;

%dsActive = (resample(double(active),2000/nRMS,2000)>0.5);
subjRMS = resample(subj,2000/nRMS,2000);
index = 1;
nRolling = 400;
figure;
thresh3 = 0.1;

subplot(411)
T = getTEO(subj,3);
%T = T./maxFilter(T,nRolling);
plot(T,'b');
hold on;
thresh = 2*abs(mean(T(1:100)));
plot(T.*(T>thresh),'r')

subplot(412)
R = rmsFilter(subj,nRMS);
%R = R./maxFilter(R,nRolling/nRMS);
plot(R,'b');
hold on;
threshRMS =sfFixed*abs(mean(R(1:floor(100/nRMS))));
plot(R.*(R>threshRMS),'r')

subplot(413)
A = getMovMax(subj);
plot(A,'b');
hold on;
plot(A.*(A>thresh3),'r')

subplot(414)
score = sfFixed*abs(mean(subj(1:100)));%(rmsFilter(sensor{1:10000,index},nRMS));
plot(subj,'b');
hold on;
plot(subj.*(abs(subj)>score),'r')
refline(0,score);

figure;
subplot(611)
res1 = splitClassification(subj,T<thresh);
plot(res1(1,:),'b');
hold on;
plot(res1(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('TEO method');

subplot(612)
crit2 = resample(double(R<threshRMS),2000,2000/nRMS);
crit2 = crit2 > 0.5;
res2 = splitClassification(subj,crit2(1:length(subj)));
plot(res2(1,:),'b');
hold on;
plot(res2(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('Fixed threshold, RMS filter used');

subplot(613)
res3 = splitClassification(subj,A<thresh3);
plot(res3(1,:),'b');
hold on;
plot(res3(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('MOVMAX method');

subplot(614)
golayEssentials = sgolayfilt(abs(hilbert(subj)),7,911);
res4 = splitClassification(subj,peakActDet(golayEssentials));
plot(res4(1,:),'b');
hold on;
plot(res4(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('PeakDetect based method');

%{
subplot(614)
res4 = splitClassification(subj,abs(subj)<score);
plot(res4(1,:),'b');
hold on;
plot(res4(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('Fixed threshold, time domain without RMS filter');
%}

subplot(615)
hold on;
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
rmsSubj = rmsFilter(subj./mean(subj),nRMS);
TSubj = length(rmsSubj);
[hmmRMS, ~, ~, vpathRMS, ~, ~, ~] = hmmmar(rmsSubj',TSubj,options);
colours = ['b','r'];
powers = zeros(1,K);
predictedStates = cell(1,K);

crit5 = round(resample(double([ones(order,1);vpathRMS]),2000,2000/nRMS));
crit5 = crit5(1:length(subj));
for j = 1:K
    predictedStates{j} = subj.*(crit5==j)';
    powers(j) = std(predictedStates{j});
    predictedStates{j}(predictedStates{j}==0)=NaN;
end
[~,permsRMS] = sort(powers);
colours = colours(permsRMS);
for j = 1:K
    plot(predictedStates{j},colours(j),'DisplayName',['State ', num2str(j)]);
end
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('HMMAR, RMS filter used on input');

subplot(616)
hold on;
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
title('HMMAR, no RMS filter');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);

if (knownActive)
results{1} = classperf(active,(T>thresh));
results{2} = classperf(dsActive,(R>threshRMS));
results{3} = classperf(active,(A>thresh3));
results{4} = classperf(dsActive,(C>score));
results{5} = classperf(dsActive(1:length(vpathRMS)),(vpathRMS==permsRMS(2))');
results{6} = classperf(active(1:length(vpathTime)),(vpathTime==permsTime(2))');
end