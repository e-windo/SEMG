function lockXY(ax,lockX,lockY)
disc = '';
lockX = double(lockX);
lockY = double(lockY);

if ~((lockX == 1) || (lockX == 0))
    disp('Invalid lockX')
    lockX = 0;
end
if ~((lockY == 1) || (lockY == 0))
    disp('Invalid lockY')
    lockY = 0;
end

if lockX == 1
    disc = [disc,'x'];
end
if lockY == 1
    disc = [disc,'y'];
end
cat = [];
for i = 1:length(ax)
    cat = [cat,ax{i}];
end
try
    if ~isempty(disc)
        
        linkaxes(cat,disc);
    else
        linkaxes(cat,'off');
    end
catch
    disp('Linkaxes failed :/ ');
end
end