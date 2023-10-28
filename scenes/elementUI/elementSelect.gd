extends VBoxContainer
signal highlighted

@onready var thisElement = get_parent()
func _get_drag_data(_position):
	var preview = thisElement.duplicate(DUPLICATE_USE_INSTANTIATION)
	preview.modulate ='#cbffffff'
	set_drag_preview(preview)
	return {'origin':thisElement}
	
func _can_drop_data(_position,_data):
	if _data['origin'] == thisElement:
		return false
	if typeof(_data) != TYPE_DICTIONARY or not(_data.has('origin')) or thisElement.active_mode == 1:
		return false
	return true
	
func _drop_data(_position,_data):
	var flowContainer = thisElement.get_parent().find_child("content",true,false)
	flowContainer.callv("_drop_data",[_position,_data])
	
func _on_select_gui_input(event):
	if event is  InputEventMouseButton and  event.get_button_index()==1:
		if event.double_click:
			if thisElement.active_mode > 1:
				$"%ElementProperties".visible = not $"%ElementProperties".visible
		elif event.pressed:
			if thisElement.active_mode > 1:
				emit_signal('highlighted',thisElement)
		
