function normalisedData = normData(data,mode,varargin)
%Apply normalisation methods to input data.
%Mostly unused in practice.

p = inputParser;
defaultMode = 'r';
defaultMethod = {'euclidean'};

modeOptions = {'r','c'};
normMethods = {'euclidean','none'};

p.addRequired('data',@istable);
p.addOptional('mode',defaultMode,@(x)(any(validatestring(x,modeOptions))));
p.addParameter('method',defaultMethod,@(x)(any(validatestring(x,normMethods))));
p.parse(data,mode,varargin{:});
data = table2array(p.Results.data);
if (strcmp(p.Results.mode,'c'))
    data = data';
end
data = data - mean(data,2);
normValues = ones(size(data,1),1);
for i = 1:size(data,1)
    temp = data(i,:);
    switch p.Results.method
    case normMethods{1}
        normValues(i) = sqrt(temp*temp');
    otherwise
        normValues(i) = 1;
    end
end

normalisedData = data ./ normValues;

if (strcmp(p.Results.mode,'c'))
    normalisedData = normalisedData';
end

normalisedData = array2table(normalisedData,'RowNames',p.Results.data.Properties.RowNames,'VariableNames',p.Results.data.Properties.VariableNames);
end