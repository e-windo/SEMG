sensorIDX = 8;
[X,constructActive] = simulateSEMG(0,8,0.00,0.0,450);
[Y,~] = simulateSEMG(0,3,0.00,0.0,2400);
[Z,~] = simulateSEMG(0,32,0.00,0.0,200);

figure;
subplot(3,1,1)
plot(sosfilt(Hd.sosmatrix,sensor{759590:759590+length(X),sensorIDX}))
subplot(3,1,2)
construct = X+(Y(1:length(X))+circshift(Y(1:length(X)),1200))*0.4+0.2*Z(1:length(X));
plot(sosfilt(Hd.sosmatrix,construct));
subplot(3,1,3)
plot(sosfilt(Hd.sosmatrix,sensor{3000000:3000000+length(X),sensorIDX}))