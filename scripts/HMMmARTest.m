%Experimental HMMmAR analysis

addpath(genpath('.'))
DS = [];
ids = 1:5;
ulim = 800000;
hlim = 810000;
nRMS = 100;

for id = ids
    temp = sensor{ulim:hlim,id}'*10000000;
    opt = getOptimalOffset(temp,sensor{ulim:hlim,ids(1)}'*10000000);
    DS = [DS;circshift(temp,opt)];
end
DS = DS';
DT = (1:size(DS,1))./(2000/nRMS);
K = 2; % number of states
nDim = length(ids); % number of channels
N = 1; % number of trials
Fs = 200;
X = DS;
T = length(X) * ones(N,1); % number of data points

%{
hmmtrue = struct();
hmmtrue.K = K;
hmmtrue.state = struct();
hmmtrue.train.covtype = 'full';
hmmtrue.train.zeromean = 0;
hmmtrue.train.order = 0;
hmmtrue.train.orderoffset = 0;
hmmtrue.train.timelag = 1;
hmmtrue.train.exptimelag = 0;
hmmtrue.train.S = ones(ndim);
hmmtrue.train.Sind = ones(1,ndim);
hmmtrue.train.multipleConf = 0;

for k = 1:K
    hmmtrue.state(k).W.Mu_W = rand(1,ndim);
    hmmtrue.state(k).Omega.Gam_rate = randn(ndim) + eye(ndim);
    hmmtrue.state(k).Omega.Gam_rate = 0.1 * 1000 * ...
    hmmtrue.state(k).Omega.Gam_rate' * hmmtrue.state(k).Omega.Gam_rate;
    hmmtrue.state(k).Omega.Gam_shape = 1000;
end

hmmtrue.P = ones(K,K) + 100 * eye(K); %rand(K,K);
for j=1:K,
    hmmtrue.P(j,:) = hmmtrue.P(j,:) ./ sum(hmmtrue.P(j,:));
end;
hmmtrue.Pi = ones(1,K); %rand(1,K);
hmmtrue.Pi = hmmtrue.Pi./sum(hmmtrue.Pi);

[X,T,Gammatrue] = simhmmmar(T,hmmtrue,[]);
%}
%{
options = struct();
options.K = K; 
options.Fs = Fs; 
options.covtype = 'full';
options.order = 6;
options.timelag = 2; 
options.DirichletDiag = 2; 
options.tol = 1e-8;
options.cyc = 100;
options.zeromean = 0;
options.inittype = 'hmmmar';
options.initcyc = 10;
options.initrep = 5;
options.verbose = 1;
%}

options = struct();
options.K = K; 
options.covtype = 'full'; % model just variance of the noise
order = 2;
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

disp('attempt to train model?');
try
[hmm, Gamma, Xi, vpath, ~, ~, fehist] = hmmmar(X,T,options);

catch
        disp('error');
end
disp('model either trained or broken, continue...');
figure;
ax = cell(1,nDim);
for i = 1:nDim
    ax{i} = subplot(nDim,1,i);
    hold on;
    for j = 1:K
        temp = DS(order+1:end,i);
        if (j~=1)
            temp = temp.*(vpath==j);
            indices = temp == 0;
            temp(indices) = NaN;
        end
        plot(DT(order+1:end),temp,'DisplayName',['State ', num2str(j)]);
    end
    %legend('-DynamicLegend');
end

kitty = [];
for i = 1:nDim
    kitty = [kitty, ax{i}];
end
linkaxes(kitty,'x');

%{
plot(Gamma(:,1),'b');
plot(Gamma(:,2),'r');
%}
%{
optionsSpectra = struct();
optionsSpectra.Fs = 2000;
optionsSpectra.Nf = 500;
optionsSpectra.p = 0;
optionsSpectra.order = order;

fitPar = hmmspectramar(X,T,hmm,Gamma,optionsSpectra);
fitNonPar = hmmspectramt(X,T,Gamma,optionsSpectra);
%}