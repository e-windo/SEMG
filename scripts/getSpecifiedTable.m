function filtered = getSpecifiedTable(table,varargin)
p = inputParser;
permittedModes = {'exclude','include'};
defaultMode = 'exclude';
defaultKeywords = {' '};
p.addRequired('table',@(x)(istable(x)));
p.addOptional('modeRows',defaultMode,@(x)(any(strcmp(x,permittedModes))));
p.addOptional('modeCols',defaultMode,@(x)(any(strcmp(x,permittedModes))));
p.addOptional('keywordRows',defaultKeywords,@(x)(iscell(x)|ischar(x)));
p.addOptional('keywordCols',defaultKeywords,@(x)(iscell(x)|ischar(x)));
p.parse(table,varargin{:});


rows = p.Results.table.Properties.RowNames;
cols  = p.Results.table.Properties.VariableNames;

%filter all the cols
substr = regexp(cols,p.Results.keywordCols);

tally = 1;
for i = 1:length(cols)
    if isempty(substr{i})
        colIndices(tally) = i;
        tally = tally+1;
    end
end

if p.Results.modeCols == 'exclude'
    ret = table(:,colIndices);
else
    ret = table;
    try
    ret(:,colIndices) = [];
    catch
    end
end

%filter all the rows
substr = regexp(rows,p.Results.keywordRows);

tally = 1;
for i = 1:length(rows)
    if isempty(substr{i})
        rowIndices(tally) = i;
        tally = tally+1;
    end
end

if p.Results.modeRows == 'exclude'
    ret = ret(rowIndices,:);
else
    try
        ret(rowIndices,:) = [];
    catch
    end
end
filtered = ret;
end