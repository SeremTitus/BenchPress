extends VBoxContainer
signal highlighted

@onready var thisActionCall = get_parent()
func _get_drag_data(_position):
	var preview = thisActionCall.duplicate(DUPLICATE_USE_INSTANTIATION)
	preview.modulate ='#cbffffff'
	set_drag_preview(preview)
	return {'origin':thisActionCall}
	
func _can_drop_data(_position,_data):
	if _data['origin'] == thisActionCall:
		return false
	if typeof(_data) != TYPE_DICTIONARY or not(_data.has('origin')) or thisActionCall.active_mode == 1:
		return false
	return true
	
func _drop_data(_position,_data):
	var SubroutineContainer = thisActionCall.get_parent().find_child("content",true,false)
	SubroutineContainer.callv("_drop_data",[_position,_data])
	
func _on_select_gui_input(event):
	if event is  InputEventMouseButton and  event.get_button_index()==1:
		if event.double_click:
			if thisActionCall.active_mode > 1:
				$"%ActionCallProperties".visible = not $"%ActionCallProperties".visible
		elif event.pressed:
			pass
			#if thisActionCall.active_mode > 1:
			#	emit_signal('highlighted',thisActionCall)
		
