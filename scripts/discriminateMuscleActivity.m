function labels = discriminateMuscleActivity(scores)
thresh = 0.1; %idiot discriminator
labels = scores > thresh;
%{
[~,peaks] = findpeaks(scores,'MinPeakDistance',300);
labels = zeros(size(scores));
labels(peaks) = 1;
%}
end