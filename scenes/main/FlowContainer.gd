extends Control
 

var element =preload("res://scenes/elementUI/element.tscn")

func can_drop_data(_position, data):
	if typeof(data) != 18 or not(data.has('source')):
		return false
	var acceptedSources = ['SelectPanel','FlowPanel']
	for source in acceptedSources:
		if  source == data['source']:
			return true

func drop_data(_position,_data):
	if _data['source'] == 'SelectPanel':
		var elementInstance = _data['origin'].duplicate()
		add_child(elementInstance)
	if _data['source'] == 'FlowPanel':
		move_child(_data['origin'],get_child_count()-1)

func _on_FlowContainer_child_entered_tree(node):
	node.active_mode = node.mode['DISPLAY']
