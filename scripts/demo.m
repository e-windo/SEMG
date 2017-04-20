data = import_csv('Run_number_32_Plot_and_Store_Bach_and_Scale_repetitions_Rep_1.19.hpf.csv');
t = data{:,1};
sensor = getTableData(data,'EMG');
clear('data');
displayPrettyActivationSchedule(t,sensor,[1,2,3])