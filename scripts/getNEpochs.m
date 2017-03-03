 function N = getNEpochs(data,fs,duration,overlap,discard)
            if ((overlap > 0.95) || (overlap < 0)) %0.95 is a rough limit, as data quickly becomes Big
                error('Unsupported feature: Overlap has to be between 0 and 0.7');
            end
            %Finds the number of samples in the data
            nSamp = size(data,1);
            %Finds the number of samples in each subblock
            M = duration*fs;
            
            %Finds the number of subblocks, allowing for overlap
            if (discard == true)
                N = floor(((((nSamp/M)-1)/(1-overlap))+1));
            else
                N = max(ceil(((((nSamp/M)-1)/(1-overlap))+1)),1);
            end
 end