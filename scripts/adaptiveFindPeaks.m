function [locs,amplitudes,slope] = adaptiveFindPeaks(x,Fs)
%Detects peaks using an adaptive method, alternative to MATLAB's findpeaks
%Input:
%  x, data signal
%  Fs, sampling frequency of data signal
%Output:
%  locs, locations of peaks
%  amplitudes, size of peaks
%  slope between peaks

%Initialise constants
tRefractory = 3; %'empirical'
sr = -5; %'empirical'
slopeInit = mean(x)+2*std(x); %'empirical'

%Initialise required elements
locs = [-1];
amplitudes = [0];
slope = [slopeInit,zeros(1,length(x)-1)];
nPeaks = 1; %assume at least 1...
vars = movvar(x,5);

for i = 1:length(x)-1
    %next value of the slope is the previous value - delta, clamped at a
    %certain minimum value
    slope(i+1) = max(slopeInit,slope(i)+sr*(amplitudes(nPeaks)+vars(i))/Fs);
    thresh = slope(i+1);
    %If the data signal is smaller than the previous one and exceeds a threshold
    if((x(i) > thresh) && (x(i+1) < x(i)))
        %If the candidate peak is a suitable distance away from the previous
        if  (i-locs(nPeaks) > tRefractory)
            %Add peak to list
            locs = [locs,i];
            amplitudes = [amplitudes,x(i)];
            nPeaks = nPeaks + 1;
        end
        %Update slope
        slope(i+1) = x(i);
    end
end
%Select true amplitudes and peak locations
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
