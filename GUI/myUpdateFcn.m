function txt = myUpdateFcn(empt,event_obj)
% Customizes text of data tips

pos = get(event_obj,'Position');
set(0,'mm',pos);
txt = {['Time: ',num2str(pos(1))],...
	      ['Amplitude: ',num2str(pos(2))]};
      