function scores = predictMuscleActivity(data)
%Predict the quasiprobability the timepoints in a signal correspond to
%active regions.
scores = getMovMax(data);
end