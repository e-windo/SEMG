function [count,indices] = getZC(input)
%Finds zero crossings in a signal
%tic
%input = input-mean(input);
dataDelay = [0,input(1:end-1)']';
prod = dataDelay.*input;
indices = prod < 0;
count = length(prod(indices));
%secret=toc;
end
