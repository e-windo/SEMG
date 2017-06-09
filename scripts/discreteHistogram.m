function discreteHistogram(input)

if isrow(input)
    input = input';
end
figure;
span = unique(input);
sel = input ==span';
bins = sum(sel);
bins = bins ./ sum(bins);


bar(span,bins);
ylabel('Probability Mass')

end