%demoDetection

subj = sensor{1000000:1100000,index}';
subj = subj-mean(subj);
subjRMS = resample(subj,1,100);
index = 1;
nRolling = 400;
thresh = 0.1;
threshRMS = 0.5;
figure;

subplot(411)
T = getTEO(subj,100);
T = T./maxFilter(T,nRolling);
plot(T,'b');
hold on;
plot(T.*(T>thresh),'r')

subplot(412)
nRMS = 100;
R = rmsFilter(subj,nRMS);
R = R./maxFilter(R,nRolling/nRMS);
plot(R,'b');
hold on;
plot(R.*(R>threshRMS),'r')

subplot(413)
A = getMovMax(subj);
plot(A,'b');
hold on;
plot(A.*(A>thresh),'r')

subplot(414)
C = rmsFilter(subj,100);
score = 1.5*std(subj);%(rmsFilter(sensor{1:10000,index},nRMS));
refline(score,0);
plot(C,'b');
hold on;
plot(C.*(C>score),'r')

figure;
subplot(511)
plot(subj,'b');
hold on;
plot(subj.*(T>thresh),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);

subplot(512)
plot(subjRMS,'b');
hold on;
plot(subjRMS.*(R>threshRMS),'r');
axis([1,length(subjRMS),1.1*min(subjRMS),1.1*max(subjRMS)]);

subplot(513)
plot(subj,'b');
hold on;
plot(subj.*(A>thresh),'r');
axis([1,length(subj),1.1*min(subj),1.1*max(subj)]);

subplot(514)
plot(subjRMS);
hold on;
plot(subjRMS.*(C>score),'r');
axis([1,length(subjRMS),1.1*min(subjRMS),1.1*max(subjRMS)]);

subplot(515)
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
options.verbose = 1;
%options.onpower = 1; %Run on POWER. doesn't work though
%options.pca = 0.99;
rmsSubj = rmsFilter(subj,nRMS)*10000000;
TSubj = length(rmsSubj);
[hmm, Gamma, Xi, vpath, ~, ~, fehist] = hmmmar(rmsSubj',TSubj,options);
for j = 1:K
    plot(subjRMS(order+1:end).*(vpath==j)','DisplayName',['State ', num2str(j)]);
end
axis([1,length(subjRMS),1.1*min(subjRMS),1.1*max(subjRMS)]);
