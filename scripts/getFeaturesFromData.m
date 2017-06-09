%This function is applied to a DataBlock in order to extract a set
%of features. These features are stored in a struct, and are returned. This
%is then processed, typically using the applyToData function.

function features = getFeaturesFromData(M)
    nWaveletSubbands = 6;
    for i = 1:size(M,2)
        varName = M.Properties.VariableNames{i};
        try 
            features.(varName).mf = meanfreq(M{:,i},2000);
        catch
            features.(varName).mf = NaN;
        end
        try 
            features.(varName).imdf = medfreq(M{:,i},2000);
        catch
            features.(varName).imdf = NaN;
        end
        try 
            features.(varName).meanEMG = mean(abs(M{:,i}));
        catch
            features.(varName).meanEMG = NaN;
        end
        try
            [C,L] = wavedec(M{:,i},nWaveletSubbands,'sym4');
            [tempFeatures,split] = getWaveletPower(C,L);
            features.(varName).spectraPower = tempFeatures/(C'*C);
            features.(varName).stdFeatures = std(split,[],2)';
            mabsFeatures = mean(abs(split),2)';
            features.(varName).mabsFeatures = mabsFeatures;
            shifted = [mabsFeatures(2:end),1];
            ratioFeatures = mabsFeatures./shifted;
            features.(varName).ratioFeatures = ratioFeatures(1:end-1);
        catch
            features.(varName).spectraPower = NaN;
            features.(varName).stdFeatures = NaN;
            features.(varName).madsFeatures = NaN;
            features.(varName).ratioFeatures = NaN;
        end
    end
end