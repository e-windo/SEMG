%hello dummy

name = 'Run_number_22_Plot_and_Store_3_Rep_1.20.hpf.csv';

if (~exist('plot_clean','var')) plot_clean = false; end
if ((~plot_clean)||~exist('data','var'))
    data = import_csv(name);
    plot_clean = true;
end


%sensor = getTableData(data,'TrignoSensor1[^\d]');
sensor = getTableData(data,'EMG');

N = 100;
for i = 1:width(sensor)
    subplot(width(sensor),1,i);

    tempSensor = zeroAppend(maFilter(sensor{1:end,i},1),nextpow2(height(sensor)));
    MVC = max(tempSensor);
    std(tempSensor);
    plot(tempSensor)
end


