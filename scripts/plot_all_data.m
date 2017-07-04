%Plots ALL the data from a specified plot&store. Used in signal quality
%diagnostics

name = 'Run_number_12_MVC_(EMG_RMS)_Left_biceps_brachii_Rep_1.8.hpf.csv';

if (~exist('plot_clean','var')) plot_clean = false; end
if ((~plot_clean)||~exist('data','var'))
    data = import_csv(name);
    plot_clean = true;
end

clc
close all
%figure();
%hold on;

fDSamp = 600;
HD = bandpass_elliptic_v1(fDSamp);
expr = '_EMG';
nStd = 7;
t = linspace(data{1,1},data{end,1},height(data)*(fDSamp/2000))';
for i = 2:width(data)-1
    temp = regexp(data.Properties.VariableNames{i},expr);
    if (~isempty(temp))
        fig = figure();
        set(fig,'name',name);
        hold on;
        tempData = resample(data{:,i},fDSamp,2000);
        subplot(3,1,1)
        %plotDat=rParabEmd__L(sosfilt(HD.sosMatrix,zscore(tempData)),40,40,1);
        hold on;
        %{
        for i = 1:size(plotDat,2)
            figure();
            subplot(2,1,1)
            plot(t,mean(plotDat(:,i:end),2));
            subplot(2,1,2)
            plot(t,plotDat(:,i));
        end
        %}
        plotDat =sosfilt(HD.sosMatrix,zscore(tempData));
        lFilt = 71;
        %filtDat = sgolayfilt(tempData,10,lFilt);
        %plotDat = filtDat(1:end-lFilt);
        plot(t(1:length(plotDat)),plotDat,'DisplayName','Filtered Data');
        %plot(t(1:length(plotDat)),mean(plotDat(:,size(plotDat,2)-3:end),2),'DisplayName',data.Properties.VariableNames{i});
        %axis([t(1),t(length(plotDat)),mean(plotDat)-nStd*std(plotDat),mean(plotDat)+nStd*std(plotDat)]);
        legend('-DynamicLegend');
        h=title(data.Properties.VariableNames(i));
        set(h,'interpreter','none');
        subplot(3,1,2);
        plot(data{:,1},data{:,i},'DisplayName','Original Data');
        axis([data{1,1},data{end,1},mean(data{:,i})-nStd*std(data{:,i}),mean(data{:,i})+nStd*std(data{:,i})]);
        legend('-DynamicLegend');
        ax=subplot(3,1,3);
        aNiceFSpectrum(data{:,1},data{:,i}-mean(data{:,i}),fDSamp,ax);
    end
end
