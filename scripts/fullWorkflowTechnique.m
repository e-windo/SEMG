%clearvars;
subtypes = {{'detache','shiftfast','','','shiftslow'},{'detache','shiftfast','shiftslow',''},{'detacheslow','shiftslow','shiftfast','','detachefast'},{'detache','shiftslow','shiftfast',''}};
ids = [12,13,15,16];

for idIndex = 4:length(ids)
    plotID = ids(idIndex);
    subtype = subtypes{idIndex};
    
    [raw,fs] = getMVCScaledData(plotID);
    data = [];
    
    for i = 1:length(raw)
        %{
        sel = regexp(raw{i}.Properties.VariableNames,'ACC');
        offset = height(raw{i})*148/2000;
        for j = 1:width(raw{i})
            if ~isempty(sel{j})
                temp = resample(raw{i}{1:offset,j},2000,148);
                raw{i}{:,j} = temp(1:height(raw{i}));
            end
            
        end
        %}
        temp = getTableData(raw{i},'EMG|Time','modeInclude',false);
        data{i} = getTableData(temp,'Synchronisation','modeInclude',true);
    end
    finalTable = [];
    for i = 1:length(subtype)
        if ~strcmp(subtype(i),'')
            
            disp('Splitting');
            dataSectioned = splitBar(plotID,data(i),'technique',subtype{i});
            disp('Unpacking cells');
            packedStruct = unpackCellArrayAndDoAThingOnIt(dataSectioned,@(X,Y)(getFeaturesFromData(X)),{'run_number_','run_type_','epoch_'});
            disp('Unpacking structs');
            finalTable.(subtype{i}) = unpackStruct(packedStruct);
            load handel;
            %sound(y,32000);
        end
    end
    
    name = ['finalTable',num2str(plotID)];
    eval([name,'=finalTable;']);
    eval(['save(''derived Matlab bits\technique\',name,'_140617'',''',name,''');'])
end