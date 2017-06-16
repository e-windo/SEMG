%demoDetection
%results = cell(1,6);
%subj = sensor{1000000:1100000,index}';
%subj = analysis{1}';
%subj = 10^6*sgolayfilt(abs(hilbert(subj)),3,411);
%[subjClean,active,centres] = simulateSEMG(1.1,50,0,0,300);

%[corr1,~] = simulateSEMG(0,200,0.00,0.0,200);
%[corr2,~] = simulateSEMG(0,32,0.00,0.0,2400);
 subjCorr = 0*(corr1(1:length(subjClean))+corr2(1:length(subjClean))+circshift(corr2(1:length(subjClean)),1200));
 subjNoise = mean(abs(subjClean))*1.2*randn(size(subjClean));
 subj = subjClean+subjNoise+subjCorr;
% snr(subjClean,subjCorr)
% snr(subjClean,subjNoise)
 snr(subjClean,subjCorr+subjNoise)
 knownActive = false;
% %subj = subj + mean(subj)*randn(size(subj))*0.1;
% subj = subj-mean(subj);
sfFixed = 0.5;
nRMS = 40;

%dsActive = (resample(double(active),2000/nRMS,2000)>0.5);
subjRMS = resample(subj,2000/nRMS,2000);
index = 1;
nRolling = 400;
figure;
thresh3 = 0.1;


%hilbert, hilbert golay, rms, teo, abs

minPKDST = 200;
subplot(1,5,1)
temp = rmsFilter(subj,nRMS);
temp = zscore(temp);
sf = 0.15;
findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
[pks1,locs1] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
locs1 = nRMS*locs1;
title('RMS');

subplot(1,5,2)
temp = getTEO(subj,3);
temp = zscore(temp);
sf = 0.2;
findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST);
[pks2,locs2] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
title('TEO');

subplot(1,5,3)
temp = abs(subj);
temp = zscore(temp);
sf = 0.45;
findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST);
[pks3,locs3] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
title('abs(time)');

subplot(1,5,4)
temp = abs(hilbert(subj));
temp = zscore(temp);
sf = 0.45;
findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST);
[pks4,locs4] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
title('Hilbert spectrum');

subplot(1,5,5)
temp = sgolayfilt(abs(hilbert(subj)),3,111);
temp = zscore(temp);
sf = 0.3;
findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST);
[pks5,locs5] = findpeaks(temp,'MinPeakProminence',sf*max(temp),'MinPeakDistance',minPKDST/nRMS);
title('Smoothed Hilbert spectrum')

results = zeros(1,5);
nPeaks = zeros(1,5);
for i = 1:5
    eval(['locs = locs',num2str(i),';']);
    indices = 1:length(centres);
    indices = indices(centres==1)+150;
    b = min(abs(indices-locs'),[],2);
    results(i) = mean(b);
    nPeaks(i) = length(locs);
    subplot(1,5,i);
    xlabel('Samples/N');
    ylabel('Amplitude');
end
