[num,txt,raw] = xlsread('timings_22.xlsx','timings');
firstcol = raw(:,1);
firstcol(cellfun(fh,firstcol)) = {'NO'};
firstrow = raw(1,:);
firstrow(cellfun(fh,firstrow)) = {'NO'};
matchesCol = regexp(firstcol,'(^[A-Z]\d.*)','match');
matchesRow = regexp(firstrow,'(^.*Plot and Store.*)','match');
nPlotAndStore = sum(~cellfun(@isempty,matchesRow));

bounds = zeros(length(matchesCol),2*nPlotAndStore);
usedIndices = ~cellfun(@isempty,matchesCol);

for i= 1:length(matchesCol)
    if usedIndices(i)==1
        for j = 0:nPlotAndStore-1
            bounds(i,1+2*j) = raw{i,4+2*j};
            bounds(i,2+2*j) = raw{i+1,4+2*j};
        end
    end
end
bounds(~usedIndices,:) = [];
rowNames = cellfun(@(x)(x(:)),matchesCol(usedIndices));
bounds = array2table(bounds,'RowNames',rowNames);
firstLetter = regexp(rowNames,'^([A-Z])','match');
uniqueFirst = unique(cellfun(@(x)(x(1)),firstLetter));

dataSectioned = cell(1,nPlotAndStore);
sectionedNames = cell(1,nPlotAndStore);
for k = 1:nPlotAndStore
   dataSectioned{k} = cell(1,length(uniqueFirst)); 
   sectionedNames{k} = cell(1,length(uniqueFirst)); 
   for i = 1:length(uniqueFirst)
      dataSectioned{k}{i} = []; 
      sectionedNames{k}{i} = {[]};
   end
end
for i = 1:length(uniqueFirst)
    for j = 1:length(firstLetter)
        if strcmp(uniqueFirst(i),firstLetter{j})
            for k = 1:nPlotAndStore
                selector = @(x)((x>bounds{j,2*k-1}')&(x<bounds{j,2*k}'));
                indices = selector(data{k}{:,1});
                N = sum(indices);
                dataSectioned{k}{i} = [dataSectioned{k}{i}',data{k}{indices,:}']';
                ords = num2words(1:N); 
                sectionedNames{k}{i} = catCell(sectionedNames{k}{i},strcat({nameFormat(rowNames{j})},{'_'},ords),'mode','h');
            end
        end
    end
end

for k = 1:nPlotAndStore
   for i = 1:length(uniqueFirst)
      dataSectioned{k}{i} = array2table(dataSectioned{k}{i},'RowNames',sectionedNames{k}{i},'VariableNames',data{k}.Properties.VariableNames); 
   end
end