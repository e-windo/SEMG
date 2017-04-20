function scores = predictMuscleActivity(data)
nRolling = 400;
nDisc = 100;
discriminatorSignal = movvar(data,nDisc);
rollingMax = maxFilter(discriminatorSignal,nRolling);
scores = discriminatorSignal ./rollingMax;
end