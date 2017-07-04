function y = nameFormat(x)
%Formats strings to nicely become row/column names in MATLAB tables
y = strrep(x,'/','_');
y = strrep(y,'-','_');
end