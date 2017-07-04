function [cocontraction] = getCocontraction(labelsX,labelsY,X,Y)
%Computes cocontraction between two muscles
%Input:
% labelsX, labels for data X
% labelsY, labels for data Y
% X, first muscle data
% Y, second muscle data
%Output:
% cocontraction, cocontraction signal consisting of concatenated
% cocontraction measures for each epoch of data

lOffset = 0.1;
uOffset = 0.2;
order = 4;
nSplit = ceil(length(X)/300);

cocontraction = zeros(1,nSplit);

%If labels do not exist, find them
if isempty(labelsX)
    labelsX = activityDetHMM(X,4,[],[]);
end
if isempty(labelsY)
    labelsY = activityDetHMM(Y,4,[],[]);
end

%Find intersection of the labels
labelsXY = labelsX & labelsY;
mutual = labelsXY.*Y(order+1:end).^2;
total = max(0.01*mean(Y.^2),labelsY.*Y(order+1:end).^2);
ratio = mutual./total;

R = length(ratio);
%Split the data into nSplit sections, compute cocontraction measure for
%each one
for i = 1:nSplit
    cocontraction(i) = mean(ratio(round(1+(i-1)*R/nSplit):round(i*R/nSplit)));
end

end