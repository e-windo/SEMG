f = figure;
dcm_obj = datacursormode(f);

set(dcm_obj,'UpdateFcn',@myUpdateFcnStart);

set(dcm_obj,'UpdateFcn',@myUpdateFcnEnd);