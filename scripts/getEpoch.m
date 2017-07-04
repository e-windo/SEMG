function D = getEpoch(data,fs,duration,overlap,discard, index)
%Selects a certain epoch from data
%Input:
% data, input data
% fs, sampling frequency of data
% duration, duration in s of epoch
% overlap, overlap between epochs
% discard, discard data that does not fit nicely into epochs or zero pad it
% index, index of epoch required
%Output:
% D, output epoch

if ((overlap > 0.95) || (overlap < 0)) %0.95 is a rough limit, as data quickly becomes Big
    error('Unsupported feature: Overlap has to be between 0 and 0.7');
end
%Finds the number of samples in the data
nSamp = size(data,1);
%Finds the number of samples in each subblock
M = duration*fs;
%Finds the number of subblocks, allowing for overlap
N = getNEpochs(data,fs,duration,overlap,discard);

if index > N
    error('Insufficient epochs in the dataset to access that index');
end

%Finds the total time covered by the blocks (allowing for
%partially empty blocks at the end)
T = ((N-1)*(1-overlap)+1)*M;

%Zero pads the data so that the blocks fit nicely
arr = table2array(data);
arr=[arr',zeros(size(arr,2),int32(T-nSamp))]';

%creates a temp variable to copy the old data into
D = arr(int32(1+(index-1)*M*(1-overlap)):int32((index-1)*M*(1-overlap)+M),:);
try
    newRowNames = data.Properties.RowNames(int32(1+(index-1)*M*(1-overlap)):int32((index-1)*M*(1-overlap)+M));
    D = array2table(D,'VariableNames',data.Properties.VariableNames,'RowNames',newRowNames);
catch
    try
        %newRowNames = data.Properties.RowNames;
        ords = num2words(1:size(D,1)); %word numbers are preferable due to an unpleasant kink in matlab where unwanted spaces are inserted during cellstr
        temp = strcat(data.Properties.RowNames{1},ords);
        D = array2table(D,'VariableNames',data.Properties.VariableNames,'RowNames',temp);
    catch
        D = array2table(D,'VariableNames',data.Properties.VariableNames);
        
    end
end
end

