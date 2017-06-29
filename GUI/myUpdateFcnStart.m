function txt = myUpdateFcnStart(empt,event_obj)
% Customizes text of data tips

pos = get(event_obj,'Position');
set(0,'template_start',pos);
txt = {['Start location:' ,num2str(pos(1))],...
	      ['Amplitude: ',num2str(pos(2))]};
      