function table = unpackStruct(struct)
%for every field, get returned table
%append names, add to current table
table = [];
fieldNames = fields(struct);
%If at the bottom
if ~isstruct(struct.(fieldNames{1}))
    data = [];
    varNames = [];
    for i = 1:length(fieldNames)
        contents = struct.(fieldNames{i});
        data = horzcat(data,contents);
        nElementsInField = length(contents);
        repeatedName = repmat(fieldNames(i),1,nElementsInField); %we want a variable name for each element, it has to be different so we append a number
        ords = num2words(1:nElementsInField); %word numbers are preferable due to an unpleasant kink in matlab where unwanted spaces are inserted during cellstr
        repeatedName = strcat(repeatedName,{'_'},ords);
        varNames = horzcat(varNames,repeatedName);
    end
    varNames = cellstr(varNames);
    table = array2table(data,'VariableNames',varNames,'RowNames',{'_'});
else
    for i = 1:length(fieldNames)
        newRows = unpackStruct(struct.(fieldNames{i}));
        rowNames = strcat(fieldNames{i},newRows.Properties.RowNames);
        newRows.Properties.RowNames = rowNames;
        table = [table; newRows];
    end
end
end