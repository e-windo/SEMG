function results = getWaveletFeatureVector(data,fs)
%Extracts features from data
%Inputs:
% data, cell array of tables
% fs, sampling frequency
%Output:
% results, cell array of tables of features
assert(iscell(data),'Data must be a cell array');
features = [];

nRMS = 1;
fs = fs/nRMS;
for i = 1:length(data)
    disp(['Currently on plotandstore ',num2str(i), ' out of ', num2str(length(data))])
    assert(ismatrix(data{i}),'Cell contents must be arrays');
    emgData = getTableData(data{i},'EMG');
    L = 2000;
    duration = 2;
    overlap = 0;
    N = getNEpochs(emgData,fs,duration,overlap,true);
    disp([num2str(N),' epochs present.'])
    
    for j = 1:N
       tempData = getEpoch(emgData,fs,duration,overlap,true,j);
       featureTable.(['epoch_',num2str(j)]) = getFeaturesFromData(tempData);
       if (round(mod(j,floor(N/10)))==0)
        disp(['Progress: ',num2str(round(100*j/N)),'% of iteration ',num2str(i)])
       end
    end
    results{i} = tableifyStruct(featureTable);
    %{
    fieldsTemp = fields(extractedData.(char(fields1(i))).(char(fields2(j))));
    tally = 0;
    for k = 1:length(fields3)
        %Do operation on the result from each epoch
        tally = tally+1;
        rowNames{tally} = [char(fields1(i)),'_',char(fields2(j)),'_',char(fields3(k))];
        try
            fields4 = fields(extractedData.(char(fields1(i))).(char(fields2(j))).(char(fields3(k))));
        catch
            wtf=1; %this should never happen
        end
        if ~hasColNames %if we don't have column names, extract them from the data
            hasColNames =  true;
            for l = 1:length(fields4)
                temp = fields4(l);
                nElementsInField = length(extractedData.(char(fields1(i))).(char(fields2(j))).(char(fields3(k))).(char(fields4(l))));
                temp = repmat(temp,1,nElementsInField); %we want a variable name for each element, it has to be different so we append a number
                ords = num2words(1:nElementsInField); %word numbers are preferable due to an unpleasant kink in matlab where unwanted spaces are inserted during cellstr
                temp = strcat(temp,{'_'},ords);
                colNames = horzcat(colNames,temp);
            end
            colNames = cellstr(colNames);
        end
        
        temp = [];
        for l = 1:length(fields4)
            %Combine all the results into a single vector of data
            temp2 = extractedData.(char(fields1(i))).(char(fields2(j))).(char(fields3(k))).(char(fields4(l)));
            if isrow(temp2)
                temp = horzcat(temp,temp2);
            else
                temp = horzcat(temp,temp2');
            end
            
        end
        conglom{count} = temp;
    end
    rowNames = cell(1,nFeatures);
    for j = 1:nFeatures
       rowNames{j} = [emgData.Properties.VariableNames{floor((j-1)/(nFeaturesPerRow))+1},'_',num2str(1+mod(j-1,nFeaturesPerRow))];
    end
    varNames = cellstr(strsplit(num2str(1:N),' '));
    varNames = strcat('epoch_',varNames);
    results{i} = array2table(featureTable,'RowNames',rowNames,'VariableNames',varNames);
    %}
end
end

        