wId = 'MATLAB:handle_graphics:exceptions:SceneNode';
warning('off',wId);
Q = cell(1,4);
traceOptions = {'A\d','B\d','C\d','D\d','E\d','F\d','S\d','T\d','.\d'};
muscleOptions = {'r1R','r2R','r3R','r4R','r5L','r6R','r7L','r8R','r9L','r10R','r11L','r12R','r13L'};
order = 100;
Hd = lpfFatigueDiag();
SOS = Hd.sosmatrix;
tempResults = false(length(muscleOptions),length(traceOptions));
for iTrace = 1:length(traceOptions)
for iMuscle = 1:length(muscleOptions)
    for i = 1:4
        Q{i} = getTableData(eval(['finalTable3',num2str(i)]),[traceOptions{iTrace},'.*',muscleOptions{iMuscle}],'modeRowVar',true);
    end
    
    for i = 1:1
        figure('units','normalized','outerposition',[0 0 1 1]);
        for j = 1:4
            subplot(2,2,j);
            q = Q{j}{:,i};
            q(isnan(q))=0;
            q = sgolayfilt(q,5,711);
            %q = [mean(q).*ones(order,1);q];
            %q = sosfilt(SOS,q);
            plot(q(order+1:end));
            axis([1,length(q(order+1:end)),aNiceAxisLimit(q(order+1:end))]);
            title(['Participant ',num2str(j)]);%title([num2str(j),'_',traceOptions{iTrace},'_',muscleOptions{iMuscle},'_',Q{j}.Properties.VariableNames{i}]);
            xlabel('Sample /N');
            ylabel('Mean Frequency');
        end
        in = input('input pls: \n');
        try
            tempResults(iMuscle,iTrace) = in;
        catch
            disp('Intervene!');
        end
        close;
    end
end
end
results.(['RMS_',num2str(order)]) = tempResults;
warning('on',wId);