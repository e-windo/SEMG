function [data,fs] = getMVCScaledData(runNumber,varargin)
runTypes = {'Left_biceps_brachii','Left_extensor_digitorum','Left_flexor_carpi_ulnaris','Left_flexor_digitorum_superficial','Left_triceps_brachii','Right_anterior_deltoid','Right_biceps_brachii','Right_extensor_digitorum','Right_flexor_carpi_ulnaris','Right_flexor_digitorum_superficialis','Right_middle_deltoid','Right_pectoralis_major_clavicular_head','Right_triceps_brachii','Plot_and_Store'};
id = 'MATLAB:table:ModifiedVarnames';
warning('off',id);
fileNames = getFileNames();
expr = ['Run_number_',num2str(runNumber),'_'];
reducedNames = {};

nRMS = 50;

for i = 1:length(fileNames)
    temp = regexp(fileNames{i},expr);
    if (~isempty(temp))
        reducedNames = catCell(reducedNames,fileNames(i));
    end
end
sorted = cell(1,length(runTypes));
for i = 1:length(runTypes)
    tempCell = {};
    for j = 1:length(reducedNames)
        if (~isempty(regexp(reducedNames{j},runTypes{i})))
            tempCell = catCell(tempCell,reducedNames(j));
        end
    end
    sorted{i} = unique(tempCell);
end

%Compute MVC for muscles
MVC = zeros(1,length(runTypes)-1);

for i = 1:length(runTypes)-1
   tempMVC = 0;
   for j = 1:length(sorted{i})
        plotAndStore = import_csv(sorted{i}{j});
        fs = 1/(plotAndStore{2,1}-plotAndStore{1,1});
        tempMVC = tempMVC+max(maFilter(rmsFilter(plotAndStore{:,2},nRMS),1000));
   end
   MVC(i) = tempMVC/length(sorted{i});
end

%Scale actual data by the MVC
data = cell(1,length(sorted{end}));
for i = 1:length(sorted{end})
    plotAndStore = import_csv(sorted{end}{i});
    RMSFiltered = zeros(size(plotAndStore,1)/nRMS,size(plotAndStore,2));
    for j = 1:size(plotAndStore,2)
        RMSFiltered(:,j) = rmsFilter(plotAndStore{:,j},nRMS);
    end
    for j = 1:length(sorted)-1
       matchesMuscle = ~cellfun(@isempty,regexp(plotAndStore.Properties.VariableNames,changeFormatFilenameToTable(runTypes{j})));
       matchesEMG    = ~cellfun(@isempty,regexp(plotAndStore.Properties.VariableNames,'EMG'));
       matchesBoth   = matchesEMG&matchesMuscle;
       try
       RMSFiltered(:,matchesBoth) = 100 .* RMSFiltered(:,matchesBoth) ./ MVC(j);
       catch
          disp('ufuckedup'); 
       end
     end
    data{i} =  array2table(RMSFiltered,'VariableNames',plotAndStore.Properties.VariableNames);
end
warning('on',id);
end

function output = changeFormatFilenameToTable(filename)
    try
   % muscle = {filename};%regexp(filename,'RMS\)_(.*)_Rep_','tokens');
    output = filename;
    words = regexp(output,'_');
    for i = 1:length(words)
        output(1+words(i))= upper(output(1+words(i)));
    end
    output = strrep(output,'_','');
    catch
       disp('ufuckedup'); 
       output = '';
    end
end