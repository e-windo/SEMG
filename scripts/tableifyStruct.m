function table = tableifyStruct(extractedData)
%Turns a conglomerated struct into a table

%Get the fields of the returned data. (patient_one, patient_two...)
fields2 = fields(extractedData);
%for every one of the top level fields
conglom = cell(1);
count = 0;
hasColNames = false;
colNames = [];
rowNames = [];
    %For each one of these measurements, get the result from each epoch of
    %data
    for j = 1:length(fields2)
        %Get the names of each epoch of data
        fields3 = fields(extractedData.(char(fields2(j))));   
        
        for k = 1:length(fields3)
            %Do operation on the result from each epoch
            count = count+1;
            rowNames{count} = [char(fields2(j)),'_',char(fields3(k))];
            try
            fields4 = fields(extractedData.(char(fields2(j))).(char(fields3(k))));
            catch
                wtf=1; %this should never happen
            end
            if ~hasColNames %if we don't have column names, extract them from the data
                hasColNames =  true;
                for l = 1:length(fields4)
                 temp = fields4(l);
                 nElementsInField = length(extractedData.(char(fields2(j))).(char(fields3(k))).(char(fields4(l))));
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
             temp2 = extractedData.(char(fields2(j))).(char(fields3(k))).(char(fields4(l)));
             if isrow(temp2)
                  temp = horzcat(temp,temp2);
             else
                  temp = horzcat(temp,temp2');
             end
             
            end
            conglom{count} = temp;
       end
    end
trainDat = zeros(length(conglom),length(conglom{1}));
for i = 1:length(conglom)
    trainDat(i,:)=conglom{i};
end

%make a table from the data
 table=array2table(trainDat,'RowNames',rowNames,'VariableNames',colNames);
end
