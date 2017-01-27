%dummy2
close all;
for j = 1:14
    
figure;
hold on;
    keywR = ['Sensor',num2str(j)];
keywC = 'ratioFeatures_five';
d = [];
for i = 1:3
    a=getSpecifiedTable(features{i},'modeRows','include','keywordRows',keywR,'modeCols','include','keywordCols',keywC);
    plot(a{:,:})
    d = [d, a{:,:}];
end
s(j) = anova1(d);
end