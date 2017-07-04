%A nice frequency spectrum
%https://uk.mathworks.com/matlabcentral/answers/36430-plotting-the-frequency-spectrum
function aNiceFSpectrum(x,Fs,varargin)
%Plots a nice frequency spectrum.
%Input: 
%  x, data signal
%  Fs, sampling frequency of data
%  handle, parameter to plot onto 
%  mode, plot in dB or linear

   p = inputParser;
   defaultHandle = gca;
   defaultMode = true;
   t = (1:length(x))./Fs;
   validationFcn = @(x)(ishandle(x));
   p.addParameter('handle',defaultHandle,validationFcn);
   p.addParameter('mode',defaultMode,@islogical);
   p.parse(varargin{:});
   
   N = length(t);
   
   %% Fourier Transform:
   X = fftshift(fft(x));
   %% Frequency specifications:
   dF = Fs/N;                      % hertz
   f = -Fs/2:dF:Fs/2-dF;           % hertz
   %% Plot the spectrum:  
   if p.Results.mode
       plot(p.Results.handle,f,abs(X)/N);
   
   else
       plot(p.Results.handle,f,20*log10(abs(X)/N));
   
   end
   xlabel('Frequency / Hz');
   ylabel('Amplitude / V');
   title('Magnitude Response');