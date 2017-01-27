[data,fs] = getMVCScaledData(22);
features = getWaveletFeatureVector(data,fs);
nD = cell(size(features));
for i = 1:length(features)
    nD{i} = normData(features{i},'r','method','euclidean');
end
