%This script runs and tests the activity detection methods on either real
%or simulated data.

results = cell(1,6);

%%Select the data to process
%subj = sensor{1000000:1100000,index}';
%subj = analysis{1}';
%subj = 10^6*sgolayfilt(abs(hilbert(subj)),3,411);

%%Create simulated data if necessary
%{
[subjClean,active,centres] = simulateSEMG(1.1,50,0,0,300);
[corr1,~] = simulateSEMG(0,200,0.00,0.0,200);
[corr2,~] = simulateSEMG(0,32,0.00,0.0,2400);
subjCorr = 0.22*(corr1(1:length(subjClean))+corr2(1:length(subjClean))+circshift(corr2(1:length(subjClean)),1200));
subjNoise = mean(abs(subjClean))*1.6*randn(size(subjClean));
subj = subjClean+subjNoise+subjCorr;
snr(subjClean,subjCorr)
snr(subjClean,subjNoise)
snr(subjClean,subjCorr+subjNoise)
%}

%%Do we know the true classification labels?
 knownActive = false;
 
%%Set fixed threshold for detection, RMS window size
sfFixed = 2;
nRMS = 4;

if knownActive %Resample the labels so that RMS domain labels can be allocated
    dsActive = (resample(double(active),2000/nRMS,2000)>0.5);
end
%Resample the data so that RMS domain labels can be allocated
subjRMS = resample(subj,2000/nRMS,2000);

figure;
%Threshold for movmax method
thresh3 = 0.1;

%For the TEO method, generate labels and plot the active regions
subplot(411)
T = getTEO(subj,3);
plot(T,'b');
hold on;
thresh = 2*abs(mean(T(1:100)));
plot(T.*(T>thresh),'r')

%For the fixed threshold RMS method, generate labels and plot the active regions
subplot(412)
R = rmsFilter(subj,nRMS);
plot(R,'b');
hold on;
threshRMS =sfFixed*abs(mean(R(1:floor(100/nRMS))));
plot(R.*(R>threshRMS),'r')

%For the movmax method, generate labels and plot the active regions
subplot(413)
A = getMovMax(subj);
plot(A,'b');
hold on;
plot(A.*(A>thresh3),'r')

%For the fixed threshold time domain method, generate labels and plot the active regions
subplot(414)
score = sfFixed*abs(mean(subj(1:100)));
plot(subj,'b');
hold on;
plot(subj.*(abs(subj)>score),'r')
refline(0,score);

figure;
%For the TEO method, generate labels and plot the labelled regions
subplot(611)
res1 = splitClassification(subj,T<thresh);
plot(res1(1,:),'b');
hold on;
plot(res1(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('TEO method');

%For the fixed threshold RMS method, generate labels and plot the labelled regions
subplot(612)
crit2 = resample(double(R<threshRMS),2000,2000/nRMS);
crit2 = crit2 > 0.5;
res2 = splitClassification(subj,crit2(1:length(subj)));
plot(res2(1,:),'b');
hold on;
plot(res2(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('Fixed threshold, RMS filter used');

%For the MOVMAX method, generate labels and plot the labelled regions
subplot(613)
res3 = splitClassification(subj,A<thresh3);
plot(res3(1,:),'b');
hold on;
plot(res3(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('MOVMAX method');

%For the SGHILBERT method, generate labels and plot the labelled regions
subplot(614)
golayEssentials = id(abs(hilbert(subj)),7,211);
labels4 = peakActDet(golayEssentials);
res4 = splitClassification(subj,labels4);
plot(res4(1,:),'b');
hold on;
plot(res4(2,:),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);
title('PeakDetect based method');

%For the HMMAR-RMS method, generate labels and plot the labelled regions
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

%For the HMMAR-T method, generate labels and plot the labelled regions
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

%If we know the true labels, compute classification performance for each
%method
if (knownActive)
results{1} = classperf(active,(T>thresh));
results{2} = classperf(dsActive,(R>threshRMS));
results{3} = classperf(active,(A>thresh3));
results{4} = classperf(active,labels4);
results{5} = classperf(active(1:length(crit5)),(crit5==permsRMS(2))');
results{6} = classperf(active(1:length(vpathTime)),(vpathTime==permsTime(2))');
end