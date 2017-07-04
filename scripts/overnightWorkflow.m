%Runs entire workflow (overnight...)
try 
    %run('fullWorkflowCocontraction');
catch
end
try
    run('fullWorkflowTechnique')
catch
end