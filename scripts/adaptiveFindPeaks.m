function [locs,amplitudes,slope] = adaptiveFindPeaks(x,Fs,varargin)

tRefractory = 3; %'empirical'
sr = -5; %'empirical'
locs = [-1];
amplitudes = [0];
slopeInit = mean(x)+2*std(x);
slope = zeros(1,length(x));
slope(1) = slopeInit; %'empirical'
stdX = std(x);
thresh = 0.2*max(x); %'empirical'
%don't pad x for now, initial thresh should be enough
nPeaks = 1;
vars = movvar(x,5);

for i = 1:length(x)-1
   slope(i+1) = max(slopeInit,slope(i)+sr*(amplitudes(nPeaks)+vars(i))/Fs);
   thresh = slope(i+1);
   if((x(i) > thresh) && (x(i+1) < x(i)))
       if  (i-locs(nPeaks) > tRefractory)
       locs = [locs,i];
       amplitudes = [amplitudes,x(i)];
       nPeaks = nPeaks + 1;
       slope(i+1) = x(i);
       end
       slope(i+1) = x(i);
   end
end

locs = locs(2:end);
amplitudes = amplitudes(2:end);

%{
figure
hold on;
plot(x,'r')
scatter(locs,amplitudes,'filled');
plot(slope);
%}
end
