function lim = aNiceAxisLimit(input,varargin)
%Creates nice axis limits for the y axis
%Input: 
%  input, signal being plotted
%  sf, scale factor away from the centre to consider
%Output:
%  lim, y axis limit

xbar = mean(input);
input = input-xbar;
defaultSf = 1.1;
p = inputParser();
p.addParameter('sf',defaultSf,@isnumeric);
p.parse(varargin{:});
sf = p.Results.sf;
mx = max(input);
mn = min(input);
lim = sf*[mn,mx]+xbar;
end