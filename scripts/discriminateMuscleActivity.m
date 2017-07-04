function labels = discriminateMuscleActivity(scores)
%Given quasiprobability scores, compute the estimated labels

thresh = 0.3; %idiot discriminator
labels = scores > thresh;
%{
[~,peaks] = findpeaks(scores,'MinPeakDistance',300);
labels = zeros(size(scores));
labels(peaks) = 1;
%}
end