%%Utility to convert ALL .hpf files in a directory into .csv format

[success, path] = system('cd');
[success, files] = system('dir /b /a-d');
expr = '.hpf$';
splitFiles = strsplit(files,'\n');
filteredFiles = regexp(splitFiles, expr);
for i = 1:length(filteredFiles)
    temp = filteredFiles(i);
    if (~isempty(temp{1}))
        temp = splitFiles(i);
        absFP = [strtrim(path),'\',temp{1}];
        command = ['DelsysFileUtil.exe -nogui -o CSV -i "',absFP,'"'];
        [a,b] = system(command);
        if (a~=0)
            echo(['Issue processing file: ',absFP])
        end
    end
end


