%Plots fatigue features for non-segmented data
close all;
for j = 1:14
    
figure;
hold on;
    keywR = ['Sensor',num2str(j)];
keywC = 'ratioFeatures_one';
d = [];
for i = 1:3
    a=getSpecifiedTable(features{i},'modeRows','include','keywordRows',keywR,'modeCols','include','keywordCols',keywC);
    plot(a{:,:},'DisplayName',['Run ', num2str(i)])
    d = [d, a{:,:}];
end
legend('-DynamicLegend');
%s(j) = anova1(d);
end