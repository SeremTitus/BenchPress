extends Node


var displaytype = ''

func _on_TextureRect_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed:
		$"%PopupMenu".popup()
