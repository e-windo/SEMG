start1 = 1160000;
start2 = 665400;
offset = 10000;
analysis{1} = sensor{start1:start1+offset,3};
analysis{2}=sensor{start2:start2+offset,1};
analysis{3}=sensor{start1:start1+offset,6};

titles = {'RPMCH','RMD','RTB'};
figure;
for i = 1:3
    subplot(3,1,i);
    plot(analysis{i});
    axis([0,offset,aNiceAxisLimit(analysis{i})])
    title(['Trace for ',titles{i}]);
    xlabel('Samples/N');
    ylabel('Amplitude/V');
end