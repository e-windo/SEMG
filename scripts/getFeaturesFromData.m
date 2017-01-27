%This function is applied to a SensiumDataBlock in order to extract a set
%of features. These features are stored in a struct, and are returned. This
%is then processed, typically using the applyToData function.

function features = getFeaturesFromData(M)
    nWaveletSubbands = 6;
    for i = 1:size(M,2)
        varName = M.Properties.VariableNames{i};
        try 
            L = length(M{:,i});
            Y = fft(M{:,i});
            P2 = abs(Y)/L;
            P1 = P2(1:L/2+1);
            C = cumsum(P1);
            [~,loc] = max(C>C(end)/2);
            medFreq = P1(loc);
            features.(varName).imdf = medFreq;
        catch
            features.(varName).imdf = NaN;
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