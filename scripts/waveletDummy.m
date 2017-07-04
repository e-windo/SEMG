%Experimental script for wavelet denoising

name = 'Run_number_22_Plot_and_Store_2_Rep_1.19.hpf.csv';

if (~exist('plot_clean','var')) plot_clean = false; end
if ((~plot_clean)||~exist('data','var'))
    data = import_csv(name);
    plot_clean = true;
end
sensor = getTableData(data,'EMG');


tempDat = sensor{:,2};
nRows = 64;
tempDat = reshape(tempDat',nRows,[]);
powers = zeros(nRows,7);
dwtmode('zpd');
for i = 1:nRows
    %subplot(width(sensor),1,i);
    [C,L] = wavedec(tempDat(i,:),6,'sym4');
    powers(i,:)= getWaveletPower(C,L)/(C*C');
    
end
for i = 1:7
   barbarian{i} = subplot(7,1,i);
   plot(powers(:,i));
end
for i = 1:7
   subplot(barbarian{i});
   tightfit(i,7,'v');
end