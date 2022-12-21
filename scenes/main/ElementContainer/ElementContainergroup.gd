extends Control


var LabelName = 'ADD VARIABLE' setget set_lable

func set_lable(newvalue):
	LabelName = newvalue
	if $"%items".visible:
		$"%Label".text = '^ ' + LabelName.capitalize()
	else:
		$"%Label".text ='> ' + LabelName.capitalize()
		
func toggle_items(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed:
		$"%items".visible = not $"%items".visible
		set_lable(LabelName)

func add_item(item:Object):
	$"%items".add_child(item)
