function dataSectioned = splitBar(plotID,data,type,subtype)
%Splits data into sections based on labels in an external spreadsheet
%Inputs:
% plotID, index of the data run to consider
% data, the data to be sectioned
% type, type of study - fatigue, technique, or performance
% subtype, type of technique - such detache/shift/unstressed/stressed
%Output:
% dataSectioned, cell array of segmented data

if strcmp(type, 'fatigue')
    [num,txt,raw] = xlsread('FATIGUE_AMENDED.xlsx',['timings_',num2str(plotID)]);
elseif strcmp(type,'technique')
    [num,txt,raw] = xlsread('TECHNIQUE_AMENDED.xlsx',[num2str(plotID),'_',subtype]);
elseif strcmp(type,'performance')
    [num,txt,raw] = xlsread('PERFORMANCE_AMENDED.xlsx',[num2str(plotID),'_',subtype]);
end
fh = @(x) all(isnan(x(:)));
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
   dataSectioned{k} = cell(1,length(firstLetter)); 
   sectionedNames{k} = cell(1,length(firstLetter)); 
   %{
    for i = 1:length(uniqueFirst)
      dataSectioned{k}{i} = []; 
      sectionedNames{k}{i} = {[]};
   end
   %}
end
for i = 1:length(uniqueFirst)
    for j = 1:length(firstLetter)
        if strcmp(uniqueFirst(i),firstLetter{j})
            for k = 1:nPlotAndStore
                selector = @(x)((x>bounds{j,2*k-1}')&(x<bounds{j,2*k}'));
                indices = selector(data{k}{:,1});
                N = sum(indices);
                ords = num2words(1:N); 
                sectionedNames{k}{j} = strcat({nameFormat(rowNames{j})},{'_'},ords);
                dataSectioned{k}{j} = array2table(data{k}{indices,:},'RowNames',sectionedNames{k}{j},'VariableNames',data{k}.Properties.VariableNames);
            end
        end
    end
end

clearvars('data');

for k = 1:nPlotAndStore
    for i = 1:length(dataSectioned{k})
        fsamp = 2000;
        duration = 1;
        overlap = 0.9;
        entry = dataSectioned{k}{i};
        NEpochs = getNEpochs(dataSectioned{k}{i}{:,:},fsamp,duration,overlap,false);
        dataSectioned{k}{i} = cell(1,NEpochs);
        for j = 1:NEpochs
            temp = getEpoch(entry,fsamp,duration,overlap,false,j);
            %temp.Properties.RowNames = strcat(temp.Properties.RowNames,['_epoch_',num2str(j)]);
            dataSectioned{k}{i}{j} = temp;
        end
    end
end

clearvars('entry','indices','ords');