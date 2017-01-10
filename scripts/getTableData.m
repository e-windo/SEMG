function reducedData = getTableData(sourceTable,expr)
p = inputParser;
p.addRequired('table',@istable);
p.addRequired('expr',@ischar);
p.parse(sourceTable,expr);

reducedData = [];
reducedVarNames = {};
fullVarNames = p.Results.table.Properties.VariableNames;
for i = 1:length(fullVarNames)
    temp = regexp(p.Results.table.Properties.VariableNames{i},expr);
    if (~isempty(temp))
        reducedData = [reducedData,p.Results.table{:,i}];
        reducedVarNames = catCell(reducedVarNames,fullVarNames(i));
    end
end
reducedData = array2table(reducedData,'VariableNames',reducedVarNames);

