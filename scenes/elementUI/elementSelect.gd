extends Control
signal highlighted

onready var thisElement = get_parent()
func get_drag_data(_position):
	var preview = thisElement.duplicate()
	preview.modulate ='#cbffffff'
	set_drag_preview(preview)
	return {'origin':thisElement}
	
func can_drop_data(_position,_data):
	if _data['origin'] == thisElement:
		return false
	if typeof(_data) != 18 or not(_data.has('origin')) or thisElement.active_mode == 1:
		return false
	return true
	
func drop_data(_position,_data):
	var flowContainer = thisElement.thisElement
	if _data['origin'].active_mode == 1 or _data['origin'].active_mode == 3:
			var elementInstance = _data['origin'].duplicate()
			if  _data['origin'].active_mode == 3:
				_data['origin'].queue_free()
			flowContainer.add_child(elementInstance)
			elementInstance.active_mode = thisElement.active_mode
			elementInstance.get_node("%select").connect('highlighted',flowContainer,'highlight_element')
			flowContainer.move_child(elementInstance,thisElement.get_index())
	elif _data['origin'].active_mode == 2:
			flowContainer.move_child(_data['origin'],thisElement.get_index())
	
func _on_select_gui_input(event):
	if event is  InputEventMouseButton and  event.get_button_index()==1:
		if event.doubleclick:
			if thisElement.active_mode >1:
				$"%ElementProperties".visible = not $"%ElementProperties".visible
		elif event.pressed:
			if thisElement.active_mode >1:
				emit_signal('highlighted',thisElement)
		
