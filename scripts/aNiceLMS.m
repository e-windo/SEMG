function output = aNiceLMS(data,reference,varargin)
%Uses a LMS filter on given data with a reference
p = inputParser;
defaultAlgStep = 0.1;
defaultTimeStep = 1;
verifyAlgStep = @(x)(isnumeric(x)&&(x<2)&&(x>0));
p.addRequired('data',@isvector);
p.addRequired('reference',@isvector);
p.addParameter('timestep',defaultTimeStep,@isnumeric);
p.addParameter('algstep',defaultAlgStep,verifyAlgStep);
p.parse(data,reference,varargin{:});

assert(all(size(data)==size(reference)),'Input arrays not equal sizes');
if(istable(p.Results.data))
    data = table2array(p.Results.data);
else
    data = p.Results.data;
end
if(istable(p.Results.reference))
    reference = table2array(p.Results.reference);
else
    reference = p.Results.reference;
end

lms = dsp.LMSFilter(11,'StepSize',p.Results.algstep);
[y,e,w] = lms(data,reference);
%{
subplot(3,1,1)
plot(1:length(data)*p.Results.timestep,[data]);
subplot(3,1,2)
plot(1:length(data)*p.Results.timestep,[y]);
subplot(3,1,3)
plot(1:length(data)*p.Results.timestep,[e]);
%}


end