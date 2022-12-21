extends Control


func get_drag_data(_position):
	var preview = get_parent().duplicate()
	preview.modulate ='#cbffffff'
	set_drag_preview(preview)
	return {'origin':get_parent()}
	
func can_drop_data(_position,_data):
	if _data['origin'] == get_parent():
		return false
	if typeof(_data) != 18 or not(_data.has('origin')) or get_parent().active_mode == 0:
		return false
	return true
	
func drop_data(_position,_data):
	var thisElement = get_parent()
	var flowContainer = thisElement.get_parent()
	if _data['origin'].active_mode == 1 or _data['origin'].active_mode == 3:
			var elementInstance = _data['origin'].duplicate()
			if  _data['origin'].active_mode == 3:
				_data['origin'].queue_free()
			flowContainer.add_child(elementInstance)
			elementInstance.active_mode = thisElement.active_mode
			elementInstance.connect('highlighted',flowContainer,'highlight_element')
			flowContainer.move_child(elementInstance,thisElement.get_index())
	elif _data['origin'].active_mode == 2:
			flowContainer.move_child(_data['origin'],thisElement.get_index())
	
func _on_select_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed: 
		get_parent().call('highlighted')
		
