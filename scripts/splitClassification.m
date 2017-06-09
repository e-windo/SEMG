function out = splitClassification(signal,labels)
out = zeros(2,length(signal));
out(1,:) = signal.*labels;
out(2,:) = signal.*(~labels);
out(out==0) = NaN;
end