%%Reads a .csv file into a table format%%

function [output] = import_csv(file)
    output = readtable(file);
end