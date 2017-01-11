%%Reads a .csv file into a table format%%

function [output] = import_csv(file)
    output = readtable(file);
    %Nasty little formatting hack
    %output.Properties.VariableNames = strrep(output.Properties.VariableNames,'LeftFlexorDigitorumSuperficial_','LeftFlexorDigitorumSuperficialis_');
end