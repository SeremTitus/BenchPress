extends Control


func _ready():
	$"%spacer".rect_size.y = 120
	$"%spacer".rect_min_size.y = 120
	if get_parent().name == 'ChildElements':
		$"%spacer".rect_size.y = 50
		$"%spacer".rect_min_size.y = 50
	
func can_drop_data(_position, data):
	#var scroll = find_parent('FlowPanelScroll')
	# impliment scroll
	if typeof(data) != 18 or not(data.has('origin')):
		return false
	return true

func drop_data(_position,_data):
	if _data['origin'].active_mode == 1 or _data['origin'].active_mode == 3:
			var elementInstance = _data['origin'].duplicate()
			add_child(elementInstance)
			if _data['origin'].active_mode == 3:_data['origin'].queue_free()
			if get_parent().name == 'ChildElements':
				elementInstance.active_mode = elementInstance.mode['DISPLAY_IN_PARENT']
			else:
				elementInstance.active_mode = elementInstance.mode['DISPLAY']
			elementInstance.connect('highlighted',self,'highlight_element')
			move_child(elementInstance,get_child_count()-2)
			if  _data['origin'].active_mode == 3:
				_data['origin'].queue_free()
	elif _data['origin'].active_mode == 2:
			if get_parent().name == 'ChildElements':
				var elementInstance = _data['origin'].duplicate()
				add_child(elementInstance)
				elementInstance.active_mode = elementInstance.mode['DISPLAY_IN_PARENT']
				_data['origin'].queue_free()
				elementInstance.connect('highlighted',self,'highlight_element')
				move_child(elementInstance,get_child_count()-2)
			else:
				move_child(_data['origin'],get_child_count()-2)

func add_from_selectElement(_data):
	var _position = 0
	drop_data(_position,_data)

func highlight_element(_data):
	if typeof(Global.highlighted_element) == TYPE_OBJECT and (Global.highlighted_element) != null:
		Global.highlighted_element.call('toggle_highlight')
	if typeof(_data) == 17 and (_data) != null:
		_data.call('toggle_highlight')
		Global.highlighted_element =_data

func generate_PlacedElement():
	
	
	pass
	
	
	
	
	
	
	
	
	
	
