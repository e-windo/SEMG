%hello dummy
sensor = getTableData(data{1},'EMG');
set(0,'defaulttextinterpreter','none');
rightTricepBicep= [6,4];
rightDigitorumFlexorSuperficialis = [8,12];
figureDigitorumFlexorUlnaris = [8,10];
leftTricepBicep= [7,5];
leftDigitorumFlexorSuperficialis = [9,13];
leftDigitorumFlexorUlnaris = [9,11];
nRMS = 50;
figure
tidy = @(x)(strrep(x,'_','\_'));
subplot(211)
a = [];
a.name = getName(rightDigitorumFlexorSuperficialis);
a.i = eval([a.name,'(1)']);
a.j = eval([a.name,'(2)']);
hold on;
plot(rmsFilter(data{1}{:,1},nRMS),rmsFilter(sensor{:,a.i},nRMS),'DisplayName',tidy(sensor.Properties.VariableNames{a.i}))
plot(rmsFilter(data{1}{:,1},nRMS),rmsFilter(sensor{:,a.j},nRMS),'r','DisplayName',tidy(sensor.Properties.VariableNames{a.j}))
title(a.name);

subplot(212)
a.name = getName(leftDigitorumFlexorSuperficialis);
a.i = eval([a.name,'(1)']);
a.j = eval([a.name,'(2)']);
hold on;
plot(rmsFilter(data{1}{:,1},nRMS),rmsFilter(sensor{:,a.i},nRMS),'DisplayName',tidy(sensor.Properties.VariableNames{a.i}))
plot(rmsFilter(data{1}{:,1},nRMS),rmsFilter(sensor{:,a.j},nRMS),'r','DisplayName',tidy(sensor.Properties.VariableNames{a.j}))
title(a.name);

for k = 1:2
    subplot(2,1,k)
    %axis([50,53,0,130]);
    legend('-DynamicLegend');
end

%{
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


%}