function filt = getMovMax(data)
%Computes movmax scores for a given data signal

%Set parameters
nRolling = 4*400;
nDisc = 101;

%Normalise data
data = data./max(data);

%Compute moving variance
discriminatorSignal = movvar(data,nDisc);

%Set minimum value of input to get a positive score
thresh = 0.0*max(discriminatorSignal);
discriminatorSignal(discriminatorSignal < thresh) = 0;

%Compute rolling maximum, divide moving variance by it
rollingMax = maxFilter(discriminatorSignal,nRolling);
filt = discriminatorSignal ./rollingMax;
end