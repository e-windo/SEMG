%Derives fatigue measures for the fatigue dataset

clearvars;
for plotID = 32:34
    

[raw,fs] = getMVCScaledData(plotID);

for i = 1:length(raw)
   sel = regexp(raw{i}.Properties.VariableNames,'ACC');
   offset = height(raw{1})*148/2000;
   for j = 1:width(raw{i})
      if ~isempty(sel{j})
          temp = resample(raw{i}{1:offset,j},2000,148);
          raw{i}{:,j} = temp(1:height(raw{i}));
      end
       
   end
   temp = getTableData(raw{i},'EMG|Time|ACC','modeInclude',false); 
   data{i} = getTableData(temp,'Synchronisation','modeInclude',true);
end

clearvars('temp','raw','sel')

%disp('Extracting features');
%features = getWaveletFeatureVector(data,fs);
%{
nD = cell(size(features));
for i = 1:length(features)
    nD{i} = normData(features{i},'r','method','euclidean');
end
%}
disp('Splitting');
run('splitBar');
disp('Unpacking cells');
packedStruct = unpackCellArrayAndDoAThingOnIt(dataSectioned,@(X,Y)(getFeaturesFromData(X)),{'run_number_','run_type_','epoch_'});
clearvars('dataSectioned');
disp('Unpacking structs');
finalTable = unpackStruct(packedStruct);
load handel;
%sound(y,32000);
name = ['finalTable',num2str(plotID)];
eval([name,'=finalTable;']);
eval(['save(''derived Matlab bits\',name,'_100617_noACC'',''',name,''');'])
    
    clearvars;
end