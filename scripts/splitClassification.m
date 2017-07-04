function out = splitClassification(signal,labels)
%Splits a signal into two sections based on the binary labels given
out = zeros(2,length(signal));
out(1,:) = signal.*labels;
out(2,:) = signal.*(~labels);
out(out==0) = NaN;
end