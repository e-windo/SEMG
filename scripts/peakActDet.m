function labels = peakActDet(input)
FLIP = false;
if isrow(input)
    input = input';
    FLIP = true;
end
labels = zeros(size(input));
indices = (1:length(input))';
[~,locs,~,p] = findpeaks(input,'MinPeakProminence',0.3*mean(input),'MinPeakDistance',100,'annotate','extents','WidthReference','halfprom');
[~,neglocs,~,~] = findpeaks(-input,'MinPeakProminence',0.3*mean(input),'MinPeakDistance',100,'annotate','extents','WidthReference','halfprom');

for i=1:length(locs)
    [~,negLoc] = max(neglocs>locs(i));
    try
        negPlus = neglocs(negLoc);
    catch
        negPlus = length(input);
    end
    try
        
        negMinus = neglocs(negLoc-1);
    catch
        negMinus = 1;
    end
    tempInds = (indices > negMinus & indices < negPlus);
    tempInds = (input.*tempInds)>(0.3*p(i)+max(input(negMinus),input(negPlus)));
    
    
    labels = labels|tempInds;
end
labels = ~labels;
if FLIP
    labels = labels';
end
end