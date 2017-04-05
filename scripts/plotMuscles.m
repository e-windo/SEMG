%hello dummy
d = 5;
sensor = getTableData(data{d},'EMG');
set(0,'defaulttextinterpreter','none');
rightTricepBicep= [6,4];
rightDigitorumFlexorSuperficialis = [8,12];
rightDigitorumFlexorUlnaris = [8,10];
leftTricepBicep= [7,5];
leftDigitorumFlexorSuperficialis = [9,13];
leftDigitorumFlexorUlnaris = [9,11];
threeLeft = [9,11,13];
threeRight = [8,10,12];
nRMS = 2;
figure
tidy = @(x)(strrep(x,'_','\_'));
a = [];
a.name = getName(threeLeft);
a.i(1) = eval([a.name,'(1)']);
a.i(2) = eval([a.name,'(2)']);
a.i(3) = eval([a.name,'(3)']);
combined = 0;
for i = 1:3
    a.data{i} = rmsFilter(sensor{:,a.i(i)},nRMS);
    combined = combined + a.data{i}.^2;
end
X = resample(data{d}{:,1},100/nRMS,450);
for i = 1:3
    ax{i} = subplot(4,1,i); 
    Y = maxFilter(resample(a.data{i},100,450)',1);
    plot(X,Y,'r','DisplayName',tidy(sensor.Properties.VariableNames{a.i(i)}))
    title(tidy(sensor.Properties.VariableNames{a.i(i)}));
end
ax{4} = subplot(4,1,4);
plot(rmsFilter(data{d}{:,1},nRMS),sqrt(combined./3),'r','DisplayName',tidy(sensor.Properties.VariableNames{a.i(i)}))

linkaxes([ax{1},ax{2},ax{3},ax{4}],'xy');
yrange = 0;
for i = 1:3
    yrange = max(yrange,max(a.data{i}));
end

for k = 1:3
    subplot(4,1,k)
    axis([0,data{d}{end,1},ternary(nRMS==1,-yrange,0),yrange^1]);
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