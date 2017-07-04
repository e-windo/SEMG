function [act,mob,com] = getHjorthParams(data)
%Computes the Hjorth parameters for given data
%Input: 
% data, the data signal
%Output:
% act, Hjorth activity parameter
% mob, Hjorth mobility parameter
% com, Hjorth complexity parameter
act = var(data);
if iscolumn(data)
    data = data';
end
dx = diff([0,data]);
d2x = diff([0,dx]);

mob = sqrt(var(dx) / act);
com = sqrt(var(d2x)/act);
end