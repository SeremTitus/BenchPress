extends VBoxContainer

func _can_drop_data(_position, data):
	#var scroll = find_parent('FlowPanelScroll')
	# impliment scroll
	if typeof(data) != TYPE_DICTIONARY or not(data.has('origin')):
		return false
	return true
	
func _drop_data(_position,_data):
	if _data['origin'].active_mode == 1 or _data['origin'].active_mode == 3:
			var elementInstance = _data['origin'].duplicate()
			add_child(elementInstance)
			if _data['origin'].active_mode == 3:_data['origin'].queue_free()
			if get_parent().get_parent().get_parent().name == 'ChildElements':
				elementInstance.active_mode = elementInstance.mode['DISPLAY_IN_PARENT']
			else:
				elementInstance.active_mode = elementInstance.mode['DISPLAY']
			elementInstance.get_node("%select").connect('highlighted',highlight_element)
			move_child(elementInstance,get_child_count()-2)
			if  _data['origin'].active_mode == 3:
				_data['origin'].queue_free()
	elif _data['origin'].active_mode == 2:
			if get_parent().get_parent().get_parent().name == 'ChildElements':
				var elementInstance = _data['origin'].duplicate()
				add_child(elementInstance)
				elementInstance.active_mode = elementInstance.mode['DISPLAY_IN_PARENT']
				_data['origin'].queue_free()
				elementInstance.get_node("%select").connect('highlighted',highlight_element)
				move_child(elementInstance,get_child_count()-2)
			else:
				move_child(_data['origin'],get_child_count()-2)
	
func highlight_element(_data):
	if typeof(Global.highlighted_element) == TYPE_OBJECT and (Global.highlighted_element) != null:
		if not Global.highlighted_element.is_queued_for_deletion():
			Global.highlighted_element.call('toggle_highlight')
	if typeof(_data) == TYPE_DICTIONARY and (_data) != null:
		_data.call('toggle_highlight')
		Global.highlighted_element =_data
	
func _on_content_child_entered_tree(node):
	if node.name == 'spacer':
		return  ERR_UNAVAILABLE
	else:
		highlight_element(node)
