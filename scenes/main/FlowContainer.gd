extends VBoxContainer

func _can_drop_data(_position, data):
	#var scroll = find_parent('SubroutinePanelScroll')
	# impliment scroll
	if typeof(data) != TYPE_DICTIONARY or not(data.has('origin')):
		return false
	return true
	
func _drop_data(_position,_data):
	if _data['origin'].active_mode == 1 or _data['origin'].active_mode == 3:
			var ActionCallInstance = _data['origin'].duplicate()
			add_child(ActionCallInstance)
			if _data['origin'].active_mode == 3:_data['origin'].queue_free()
			if get_parent().get_parent().get_parent().name == 'ChildActionCalls':
				ActionCallInstance.active_mode = ActionCallInstance.mode['DISPLAY_IN_PARENT']
			else:
				ActionCallInstance.active_mode = ActionCallInstance.mode['DISPLAY']
			#ActionCallInstance.get_node("%select").connect('highlighted',highlight_ActionCall)
			move_child(ActionCallInstance,get_child_count()-2)
			if  _data['origin'].active_mode == 3:
				_data['origin'].queue_free()
	elif _data['origin'].active_mode == 2:
			if get_parent().get_parent().get_parent().name == 'ChildActionCalls':
				var ActionCallInstance = _data['origin'].duplicate()
				add_child(ActionCallInstance)
				ActionCallInstance.active_mode = ActionCallInstance.mode['DISPLAY_IN_PARENT']
				_data['origin'].queue_free()
				#ActionCallInstance.get_node("%select").connect('highlighted',highlight_ActionCall)
				move_child(ActionCallInstance,get_child_count()-2)
			else:
				move_child(_data['origin'],get_child_count()-2)
	

func _on_content_child_entered_tree(node):
	if node.name == 'spacer':
		return  ERR_UNAVAILABLE
