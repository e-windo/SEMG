function lookup = getFileNames
[success,files] = system('for /f "tokens=*" %G in (''dir /b /s /a-d /r "*.hpf.csv"'') do echo %G');
sp = strsplit(files,'\n');
nFiles = floor(length(sp)/2)-1;
filenames = cell(1,nFiles);
for i = 1:nFiles
    temp = sp{2*i+1};
    expr = 'D:.*\\(.*\.hpf\.csv)';
    temp = regexp(temp,expr,'tokens');
    filenames{i}=temp{:}{:};
end
    
lookup = filenames;
end