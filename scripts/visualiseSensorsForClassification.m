%For every muscle, filter and plot the signal. 

nMusc = width(sensor);

for i = 1:nMusc
figure('units','normalized','outerposition',[0 0 1 1]);
index = nMusc-i+1;
dat = id(sensor{:,index},100);
dat = sosfilt(Hd.sosMatrix,dat);
plot((1:length(dat))./2000,dat);
title(sensor.Properties.VariableNames{index});

h = zoom;
set(h,'Motion','horizontal','Enable','on');
end