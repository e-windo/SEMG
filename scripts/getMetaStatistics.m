function [statistics] = getMetaStatistics()
%Returns statistics and values from the data quality scores table
%Output: 
% statistics, struct with total data, data split by study, and summary
% statistics for the data

[~,~,raw] = xlsread('Data Quality Scores.xlsx','table');
ux = 33;
lx = 2;
uy = 16;
ly = 4;
rowNames = raw(lx:ux,2);
varNames = raw(1,ly:uy);
data = raw(lx:ux,ly:uy);

data = cellfun(@(x)(ternary(x=='X',0,x)),data,'UniformOutput',false);
data = cellfun(@(x)(ternary(x=='A',-2,x)),data,'UniformOutput',false);

dataTable = cell2table(data,'RowNames',rowNames,'VariableNames',varNames);
dataTable = dataTable(~any(dataTable{:,:}==-2,2),:);
%statTable{:,:} = statTable{:,:}.*(statTable{:,:}~='X');

rowNames = {'mean','std'};
statsTable = zeros(2,width(dataTable));

for i = 1:width(dataTable)
    statsTable(1,i) = mean(dataTable{:,i});
    statsTable(2,i) = std(dataTable{:,i});
end

statistics.dataTable = dataTable;
statistics.statsTable = array2table(statsTable,'RowNames',rowNames,'VariableNames',varNames);
statistics.performanceTable = dataTable(27:28,:);
statistics.techniqueTable = dataTable(1:18,:);
statistics.fatigueTable = dataTable(19:25,:);
end