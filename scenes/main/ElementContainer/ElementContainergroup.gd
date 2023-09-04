extends Control


var LabelName = 'ADD VARIABLE' :set=set_lable

func set_lable(newvalue):
	LabelName = newvalue
	$"%Label".text =  LabelName.capitalize()
	if $"%items".visible:
		$"%icon".position.x =17
		$"%icon".rotation =90
	else:
		$"%icon".position.x =0
		$"%icon".rotation =0
	
func toggle_items(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed:
		$"%items".visible = not $"%items".visible
		set_lable(LabelName)
	
func add_item(item:Object):
	$"%items".add_child(item)
	
