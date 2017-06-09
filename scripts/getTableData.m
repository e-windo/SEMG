function reducedData = getTableData(sourceTable,expr,varargin)
defaultModeInclude = false;
defaultModeRowVar = false;
p = inputParser;
p.addRequired('table',@istable);
p.addRequired('expr',@ischar);
p.addParameter('modeInclude',defaultModeInclude,@islogical);
p.addParameter('modeRowVar',defaultModeRowVar,@islogical);
p.parse(sourceTable,expr,varargin{:});

if (~p.Results.modeRowVar)
    temp = regexp(p.Results.table.Properties.VariableNames,expr);
    temp = xor(p.Results.modeInclude,~cellfun(@isempty,temp));
    reducedData = p.Results.table(:,temp);
else
    temp = regexp(p.Results.table.Properties.RowNames,expr);
    temp = xor(p.Results.modeInclude,~cellfun(@isempty,temp));
    reducedData = p.Results.table(temp,:);
    
end