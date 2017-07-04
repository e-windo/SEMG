%Generates and plots fatigue measures for the fatigue study, partitioned by
%section.

shift = true;
fea = 1;

finalTables.table31 = finalTable31;
finalTables.table32 = finalTable32;
finalTables.table33 = finalTable33;
finalTables.table34 = finalTable34;


sectionsA = {'B'};%{'A','B','C','D','E','F'};
sectionsB = {'S'};
sectionsC = {'T'};
nParticipants = 4;
nRepeats = 6;
for section = sectionsB
    section = section{:}; %Why would you need to do this but you do
    for k = 1:1
        clearvars('Q');
        figure('units','normalized','position',[0 0 1 1]);
        for j = 1:nParticipants
            subplot(2,2,j);
            for i = 1:nRepeats
                L = ['n',num2str(j),num2str(i)];
                muscle = num2str(k);
                Q.(L) = getTableData(finalTables.(['table3',num2str(j)]),[section,num2str(i),'_','1','.*or',muscle,'[LR].*EMG'],'modeRowVar',true);
                %Q.(L) = getTableData(finalTables.(['table3',num2str(j)]),[section,'\d.?','_',num2str(i),'.*or',muscle,'[LR].*EMG'],'modeRowVar',true);
                
                hold on;
                if shift
                    
                    opt = getOptimalOffset(Q.(['n',num2str(j),'1']){:,fea},Q.(L){:,fea});
                    temp = padarray(Q.(L){:,fea},opt,0,'pre');
                    %temp = temp-mean(temp);
                    %temp = temp/std(temp);
                else
                    temp = Q.(L){:,fea};
                end
                plot(temp(1:length(Q.(L){:,fea})),'DisplayName',['mean= ',num2str(mean(Q.(L){:,fea}))]);
                %{
                try
                [peaks,locs] = findpeaks(temp(1:length(Q.(L){:,fea})),'MinPeakProminence',0.2*std(temp));
                X = [ones(length(locs),1) locs];
                b = X\peaks;
                plot(locs,X*b,'DisplayName',['Repeat ',num2str(i)]);
                catch
                end
                %}
            end
            axis 'tight';
            xlabel('Sample /N');
            ylabel('Frequency /Hz');
            title(['Run ID = ',num2str(j) ', section = ', section,', muscle = ', muscle]);
            %if j==2
            %legend('-DynamicLegend');
            %end
        end
        %saveas(gcf,['images\fatigueDump\IMNFACCZ',section,muscle,'.jpg']);
        %{
        figure('units','normalized','outerposition',[0 0 1 1]);
        
        results = zeros(nParticipants*nRepeats);
        for m = 1:nParticipants
            for n= 1:nRepeats
                for o = 1:nParticipants
                    for p = 1:nRepeats
                        first = Q.(['n',num2str(m),num2str(n)]){:,fea};
                        second = Q.(['n',num2str(o),num2str(p)]){:,fea};
                        %first = first-mean(first);
                        %first = first / std(first);
                        %second = second-mean(second);
                        %second = second / std(second);
                        results(n+(m-1)*nRepeats,p+(o-1)*nRepeats) = dtw(first,second); 
                    end
                end
            end
        end
        imshow(results./max(max(results)),'Colormap',parula,'InitialMagnification',2000*4/nRepeats);
        xlabel('Participants 4,3,2,1');
        ylabel('Participants 4,3,2,1');
        colorbar;
        title(['DTW distances for section = ', section,', muscle = ', muscle]);
        saveas(gcf,['images\fatigueDump\distances_EMG_',section,muscle,'.jpg']);
            %}
    end
end