%Estimates active labels for the entire dataset without segmentation
clearvars;
for plotID = [34,13,15,16,31,32,33,34]
    
    
    [raw,fs] = getMVCScaledData(plotID);
    
    for i = 1:length(raw)
        temp = getTableData(raw{i},'EMG|Time','modeInclude',false);
        data{i} = getTableData(temp,'Synchronisation','modeInclude',true);
    end
    
    clearvars('temp','raw','sel')
    for i = 1:length(data)
        labels = cell(1,width(data{i}));
        for j = 1:width(data{i})
            labels{j} = activityDetHMM(data{i}{:,j},4,[],[]);
        end
        finalStruct.(['n',num2str(i)]) = labels;
    end
    
    name = ['finalStruct',num2str(plotID)];
    eval([name,'=finalStruct;']);
    eval(['save(''derived Matlab bits\cocontraction\',name,'_140617'',''',name,''');'])
    
    clearvars;
end