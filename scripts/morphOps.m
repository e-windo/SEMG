function output = morphOps(input,varargin)
%Performs erode/dilate operations to a 1D input
%Inputs:
% input, the data
%Parameters:
% erodeSpan, the size of the erosion element
% dilateSpan, the size of the dilation element
%Output:
% output, the data after erosion and dilation

defaultErode = 15;
defaultDilate = 15;
FLIP = false;
if isrow(input)
    FLIP = true;
    input = input';
end
p = inputParser;
p.addParameter('erodeSpan',defaultErode,@isnumeric);
p.addParameter('dilateSpan',defaultDilate,@isnumeric);
p.parse(varargin{:});
output = imdilate(imerode(double(input),strel('line',p.Results.erodeSpan,90)),strel('line',p.Results.dilateSpan,90));
if FLIP
    output = output';
end
end