function results = getWaveletFeatureVector(data,fs)
assert(iscell(data),'Data must be a cell array');
features = [];

nRMS = 50;
fs = fs/nRMS;
for i = 1:length(data)
    assert(ismatrix(data{i}),'Cell contents must be arrays');
    emgData = getTableData(data{i},'EMG');
    L = 2000;
    duration = 2;
    overlap = 0.5;
    N = getNEpochs(emgData,fs,duration,overlap,true);

    
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
            arr = table2array(data);
            arr=[arr',zeros(size(arr,2),int32(T-nSamp))]';
            
            %creates a temp variable to copy the old data into
            D = arr(int32(1+(index-1)*M*(1-overlap)):int32((index-1)*M*(1-overlap)+M),:);
            D = array2table(D,'VariableNames',data.Properties.VariableNames);
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
        