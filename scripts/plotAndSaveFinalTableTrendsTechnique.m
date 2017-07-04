%Generates and plots fatigue measures for the technique study, partitioned by
%section.

shift = false;
fea = 3;

finalTables.table12 = finalTable12;
%finalTables.table32 = finalTable32;
%finalTables.table33 = finalTable33;
%finalTables.table34 = finalTable34;


nTables = 4;
sections = {'G','D','A','E'};
nRepeats = 7;

for tableID = [12,13,15,16]
    subtypes = fieldnames(finalTables.(['table',num2str(tableID)]));
    for subtypeIndex = 1:length(subtypes)
        subtype = subtypes{subtypeIndex};
    for muscle = 3:13
        for sectionIndex = 1:length(sections)
            section = sections{sectionIndex};
            figure;
            for repeat = 1:nRepeats
            
            L = ['n',section,num2str(repeat)];
            muscle = num2str(muscle);
            disc = [section,num2str(repeat),'_','1','.*or',muscle,'[LR].*EMG'];
            Q.(L) = getTableData(finalTables.(['table',num2str(tableID)]).(subtype),disc,'modeRowVar',true);
            
            
            if shift
                
                opt = getOptimalOffset(Q.(['n',section,num2str(1)]){:,fea},Q.(L){:,fea});
                temp = padarray(Q.(L){:,fea},opt,0,'pre');
                %temp = temp-mean(temp);
                %temp = temp/std(temp);
            else
                temp = Q.(L){:,fea};
            end
            
            plot(temp(1:length(Q.(L){:,fea})),'DisplayName',[section,num2str(repeat)]);
                
            hold on;
            
            end
            
        legend('-DynamicLegend');
            title(['Section ', section, ' for plotAndStore ',num2str(tableID),' muscle ' ,num2str(muscle)]);
        end
    end
    end
end