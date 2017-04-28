%Version 1.01
%Now with comments!
%Objective: 
%   Read in data from a .mat file
%   Select the data needed
%   Generate corresponding time points
%   Plot the data against time
%   Plot the frequency spectrum
%
%Note: This file is slightly different to that which you saw earlier because you do not have the
%required .mat file yet. I would send it to
%you but the .mat file is very big.

%We agreed that the following two commands are not appropriate, and are
%inconvenient.
%close all;
%clear all;

%Load the data from the current directory, using the filename of the data
%load('emg_plot_32.mat');

%Declare variables as name = value pairs, to be used later
sensorIndex = 10;
samplingFrequency = 2000;
resamplingFrequency = 200;

%Select the required column from emg_plot_32, which contains all the samples from
%a single muscle. Assign that to the variable sampledData
%sampledData = emg_plot_32{1:end,sensorIndex};

%Create a new signal with frequency sineFrequency
%(A sine wave, with nSamples samples)
nSamples = 1000;
sineFrequency = 70;
sampledData = sin((1:nSamples).*((2*pi*sineFrequency)/samplingFrequency));

%Resample the data to the new sampling frequency
%The function resample takes as parameters the data to resample, the target
%frequency, and the original frequency.
resampledData = resample(sampledData,resamplingFrequency,samplingFrequency);

%Generate timepoints corresponding to the resampled data.
%e.g. resampledData(10) happens at timepoints(10)
timepoints = (1:length(resampledData))./resamplingFrequency;

%Create a new figure
figure;

%Plot the resampled data against the timepoints, the timepoints on the x
%axis
plot(timepoints,resampledData);

%Give the plot a title consisting of the name of the signal that is being plotted 

%title(emg_plot_32.Properties.VariableNames{sensorIndex});
title(['Sine wave with frequency ', num2str(sineFrequency),'Hz']);

%Set the x and y axis labels
xlabel('Time / seconds');
ylabel('Amplitude / V');

%Create a new figure so as to not overwrite the previous one
figure;

%Plot the frequency spectrum of the data signal
%The function aNiceFSpectrum takes as inputs the timepoints, the data
%signal, and the sampling frequency of the data
aNiceFSpectrum(timepoints',resampledData,resamplingFrequency);