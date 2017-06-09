function lim = aNiceAxisLimit(input,varargin)
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