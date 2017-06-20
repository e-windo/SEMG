%function [cocontraction,labelsX,labelsY,labelsXY] = getCocontraction(X,Y)
function [cocontraction] = getCocontraction(labelsX,labelsY,X,Y)
 
   lOffset = 0.1;
   uOffset = 0.2;
   order = 4;
   nSplit = ceil(length(X)/300);
   
   cocontraction = zeros(1,nSplit);
   
   %[~,hmmX,posX] = activityDetHMM(X(round(lOffset*length(X)):round(uOffset*length(X))),order,[],[]);
   %[~,hmmY,posY] = activityDetHMM(Y(round(lOffset*length(Y)):round(uOffset*length(Y))),order,[],[]);
   
   if isempty(labelsX)
       labelsX = activityDetHMM(X,4,[],[]);
   end
   if isempty(labelsY)
       labelsY = activityDetHMM(Y,4,[],[]);
   end
   
   labelsXY = labelsX & labelsY;
   mutual = labelsXY.*Y(order+1:end).^2;
   total = max(0.01*mean(Y.^2),labelsY.*Y(order+1:end).^2);
   ratio = mutual./total;
   
   R = length(ratio);
   for i = 1:nSplit
       cocontraction(i) = mean(ratio(round(1+(i-1)*R/nSplit):round(i*R/nSplit)));
   end

end