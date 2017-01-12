function featureTable = getWaveletFeatureVector(data)
assert(iscell(data),'Data must be a cell array');
features = [];
for i = 1:length(data)
    assert(ismatrix(data{i}),'Cell contents must be arrays');
    emgData = getTableData(data{i},'EMG');
    L = 10000;
    N = floor(height(emgData)/L);
    nCoefs = 6;
    nFeaturesPerRow = nCoefs+1;
    nFeatures = width(emgData)*nFeaturesPerRow;
    featureTable = zeros(nFeatures,N);
    for j = 1:N
       tempData = emgData(1+L*(j-1):L*j,:); 
       features = zeros(width(emgData),nCoefs+1);
       for k = 1:width(emgData)
            [C,L] = wavedec(tempData{:,k},nCoefs,'sym4');
            features(k,:)= getWaveletPower(C,L)/(C'*C); 
       end
       featureTable(:,j) = reshape(features',1,[])';
    end
end
rowNames = cell(1,nFeatures);
for i = 1:nFeatures
    rowNames{i} = [emgData.Properties.VariableNames{floor((i-1)/(nCoefs+1))+1},'_',num2str(1+mod(i-1,nFeaturesPerRow))];
end
varNames = cellstr(strsplit(num2str(1:N),' '));
varNames = strcat('epoch_',varNames);
featureTable = array2table(featureTable,'RowNames',rowNames,'VariableNames',varNames);
end