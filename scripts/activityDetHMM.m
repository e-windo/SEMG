function [labels,hmm,pos] = activityDetHMM(input,order,hmm,pos)
%Computes HMMAR estimates for the state labels of a sequence
%Input:
% input, data sequence in question
% order, order of HMMAR model
% hmm, previously trained HMMAR model
% pos, previously generated index corresponding to 'active' state
%Output:
% labels, boolean state labels (2 state HMM)
% hmm, trained HMMAR model
% pos, index corresponding to 'active' state


TSubj = length(input);
%If we don't have a previously trained HMM, train one on the data
if isempty(hmm)
    %If no model order specified, use a default
if isempty(order)
    order = 4;
end
%Initialise HMM training parameters
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
subj = input';
%Train model
[hmm, ~, ~, vpathTime, ~, ~, ~] = hmmmar(subj'./mean(subj),TSubj,options);
powers = zeros(1,K);
predictedStates = cell(1,K);
%Compute state powers
for j = 1:K
    predictedStates{j} = subj(order+1:end).*(vpathTime==j)';
    powers(j) = std(predictedStates{j})/sum(vpathTime==j);
end
%Find state with maximum power, use as 'active' state
[~,pos] = max(powers);
%Generate binary labels
labels = vpathTime==pos;
else %If HMM previously trained, explicitly use the viterbi algorithm to decode labels
    vPath = hmmdecode(input,TSubj,hmm,1);
    labels = vPath==pos;
end
end