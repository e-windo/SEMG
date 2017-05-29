function filt = getMovMax(data)
nRolling = 400;
nDisc = 101;
discriminatorSignal = movvar(data,nDisc);
rollingMax = maxFilter(discriminatorSignal,nRolling);
filt = discriminatorSignal ./rollingMax;
end