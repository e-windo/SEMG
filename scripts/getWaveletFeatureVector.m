function featureTable = getWaveletFeatureVector(data,fs)
assert(iscell(data),'Data must be a cell array');
features = [];
for i = 1:length(data)
    assert(ismatrix(data{i}),'Cell contents must be arrays');
    emgData = getTableData(data{i},'EMG');
    L = 10000;
    duration = 2;
    overlap = 0;
    N = getNEpochs(emgData,fs,duration,overlap,true);
    nWaveletSubbands = 6;
    nDerivedCoefs = (nWaveletSubbands+1)*3 -1;
    nFeaturesPerRow = nWaveletSubbands+nDerivedCoefs+1;
    nFeatures = width(emgData)*nFeaturesPerRow;
    featureTable = zeros(nFeatures,N);
    
    for j = 1:N
       tempData = getEpoch(emgData{:,:},fs,duration,overlap,true,j);
       features = zeros(width(emgData),nFeaturesPerRow);
       for k = 1:width(emgData)
            [C,L] = wavedec(tempData(:,k),nWaveletSubbands,'sym4');
            [tempFeatures,split] = getWaveletPower(C,L);
            tempFeatures = tempFeatures/(C'*C); 
            stdFeatures = std(split,[],2)';
            mabsFeatures = mean(abs(split),2)';
            shifted = [mabsFeatures(2:end),1];
            ratioFeatures = mabsFeatures./shifted;
            ratioFeatures = ratioFeatures(1:end-1);
            totalFeatures = [tempFeatures,stdFeatures,mabsFeatures,ratioFeatures];
            features(k,:) = totalFeatures;
            
       end
       featureTable(:,j) = reshape(features',1,[])';
       if (round(mod(j,floor(N/10)))==0)
        disp(['Progress: ',num2str(round(100*j/N)),'% of iteration ',num2str(i)])
       end
    end
end
rowNames = cell(1,nFeatures);
for i = 1:nFeatures
    rowNames{i} = [emgData.Properties.VariableNames{floor((i-1)/(nFeaturesPerRow))+1},'_',num2str(1+mod(i-1,nFeaturesPerRow))];
end
varNames = cellstr(strsplit(num2str(1:N),' '));
varNames = strcat('epoch_',varNames);
featureTable = array2table(featureTable,'RowNames',rowNames,'VariableNames',varNames);
end


function D = getEpoch(data,fs,duration,overlap,discard, index)
            if ((overlap > 0.95) || (overlap < 0)) %0.95 is a rough limit, as data quickly becomes Big
                error('Unsupported feature: Overlap has to be between 0 and 0.7');
            end
            %Finds the number of samples in the data
            nSamp = size(data,1);
            %Finds the number of samples in each subblock
            M = duration*fs;
            %Finds the number of subblocks, allowing for overlap
            if (discard == true)
                N = floor(((((nSamp/M)-1)/(1-overlap))+1));
            else
                N = ceil(((((nSamp/M)-1)/(1-overlap))+1));
            end
            
            if index > N
                error('Insufficient epochs in the dataset to access that index');
            end
            
            %Finds the total time covered by the blocks (allowing for
            %partially empty blocks at the end)
            T = ((N-1)*(1-overlap)+1)*M;
            
            %Zero pads the data so that the blocks fit nicely
            data=[data',zeros(size(data,2),int32(T-nSamp))]';
            
            %creates a temp variable to copy the old data into
            D = data(int32(1+(index-1)*M*(1-overlap)):int32((index-1)*M*(1-overlap)+M),:);

end
        
 function N = getNEpochs(data,fs,duration,overlap,discard)
            if ((overlap > 0.95) || (overlap < 0)) %0.95 is a rough limit, as data quickly becomes Big
                error('Unsupported feature: Overlap has to be between 0 and 0.7');
            end
            %Finds the number of samples in the data
            nSamp = size(data,1);
            %Finds the number of samples in each subblock
            M = duration*fs;
            
            %Finds the number of subblocks, allowing for overlap
            if (discard == true)
                N = floor(((((nSamp/M)-1)/(1-overlap))+1));
            else
                N = ceil(((((nSamp/M)-1)/(1-overlap))+1));
            end
 end
        