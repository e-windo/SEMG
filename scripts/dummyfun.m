function dummyfun(id,data)
figure
hold on
id = 4*(id-1) + 2;
plot(data{1}{:,1},data{1}{:,id});
index = abs(data{1}{:,id})>100;
scatter(data{1}{index,1},data{1}{index,id},'r');
sum(index)/length(data{1}{:,1})
end