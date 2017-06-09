function filt = getMovMaxSpike(data)
%thresh = 0.65
nRolling = 4*400;
nDisc = 101;
discriminatorSignal = movvar(data,nDisc);
thresh = 0.1*max(discriminatorSignal);
discriminatorSignal(discriminatorSignal < thresh) = 0;
rollingMax = maxFilter(discriminatorSignal,nRolling);
filt = discriminatorSignal ./rollingMax;
end