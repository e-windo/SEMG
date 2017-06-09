function [act,mob,com] = getHjorthParams(data)
act = var(data);
if iscolumn(data)
    data = data';
end
dx = diff([0,data]);
d2x = diff([0,dx]);

mob = sqrt(var(dx) / act);
com = sqrt(var(d2x)/act);