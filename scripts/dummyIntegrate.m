%dummyIntegrate
mn = 1;
mx = 30000;
nMusc = floor((width(data)-1)/4);
output = cell(1,nMusc);
maOrder = 100;
figure;
hold on

for i = 1:nMusc
offset = 3 + 4*(i-1);
output{i} = integrateAcc(data{mn:mx,offset},data{mn:mx,offset+1},data{mn:mx,offset+2},148,maOrder);
end;

for i = 1:nMusc
    output{i} = output{i}(:,maOrder*1.5:end);
    plot3S(output{i});
end;