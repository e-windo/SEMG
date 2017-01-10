%A nice frequency spectrum
%https://uk.mathworks.com/matlabcentral/answers/36430-plotting-the-frequency-spectrum
function aNiceFSpectrum(t,x,Fs,varargin)
   p = inputParser;
   paramName = 'handle';
   defaultHandle = gca;
   validationFcn = @(x)(ishandle(x));
   addParameter(p,paramName,defaultHandle,validationFcn);
   p.parse();
   
   N = size(t,1);
   
   %% Fourier Transform:
   X = fftshift(fft(x));
   %% Frequency specifications:
   dF = Fs/N;                      % hertz
   f = -Fs/2:dF:Fs/2-dF;           % hertz
   %% Plot the spectrum:  
   plot(p.Results.handle,f,abs(X)/N);
   xlabel('Frequency (in hertz)');
   title('Magnitude Response');