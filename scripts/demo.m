%Imports a specified run, extracting the sEMG components

close all;
istr = 'Run_number_34_Plot_and_Store_Bach_and_Scale_repetitions_Rep_1.15.hpf';
data = import_csv([istr,'.csv']);
t = data{:,1};
sensor = getTableData(data,'EMG');
Hd = generator_butterworth_10_500();
%run('visualiseSensorsForClassification');
%clear('data');
%displayPrettyActivationSchedule(t,sensor,[1,2,3],0.45*10^6,0.5*10^6)