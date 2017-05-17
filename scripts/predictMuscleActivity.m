function scores = predictMuscleActivity(data)
nRolling = 400;
nDisc = 101;
discriminatorSignal = movvar(data,nDisc);
rollingMax = maxFilter(discriminatorSignal,nRolling);
scores = discriminatorSignal ./rollingMax;
end