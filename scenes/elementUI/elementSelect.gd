extends Control

func get_drag_data(_position):
	var source = 'SelectPanel'
	if get_parent().active_mode != 0:
			source = 'FlowPanel'
	var preview = get_parent().duplicate()
	preview.modulate ='#cbffffff'
	set_drag_preview(preview)
	return {'origin':get_parent(),'source':source}
	

func can_drop_data(_position, data):
	if typeof(data) != 18 or not(data.has('source')) or get_parent().active_mode == 0:
		return false
	var acceptedSources = ['SelectPanel','FlowPanel']
	for source in acceptedSources:
		if source == data['source']:
			return true

func drop_data(_position,_data):
	var thisElement = get_parent()
	var flowContainer = thisElement.get_parent()
	if _data['source'] == 'SelectPanel':
		var elementInstance = _data['origin'].duplicate()
		flowContainer.add_child(elementInstance)
		flowContainer.move_child(elementInstance,thisElement.get_index())
	if _data['source'] == 'FlowPanel':
		flowContainer.move_child(_data['origin'],thisElement.get_index())

