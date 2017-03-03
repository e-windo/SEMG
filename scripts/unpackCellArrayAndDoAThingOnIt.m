function [conglom,upName] = unpackCellArrayAndDoAThingOnIt(Arr, thing, names)
if istable(Arr)
    conglom = thing(Arr);
    try
        %Arr.Properties.RowNames{1}
        upName = regexp(Arr.Properties.RowNames{1},'([\da-zA-Z]+_\d+_\d*)','match');
        upName = upName{1};
    catch
        upName = [];
    end
else
    firstName = names{1};
    upName = '';
    names = names(2:end);
    for i = 1:length(Arr)
        try
        [newData,newName] = unpackCellArrayAndDoAThingOnIt(Arr{i},thing,names);
        catch
            'can''t handle this gracefully';
        end
        newName = [newName,'_',num2str(i)];
        conglom.([firstName,'_',newName]) = newData;
    end
end