extends Node
signal changesmade

func _on_TextureRect_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed: 
		queue_free()
		emit_signal("changesmade")

func get_property_list():
	if $"%Properties".text != '':
		return [$"%Properties".text,$"%Variable".text,$"%Morph".get_item_text($"%Morph".get_selected_id()),$"%Type".get_item_text($"%Type".get_selected_id()),$"%Display".get_item_text($"%Display".get_selected_id()),$"%DisplayType".get_item_text($"%DisplayType".get_selected_id()),$"%Default".text,$"%InorOutOption".get_item_text($"%InorOutOption".get_selected_id())]
	else:
		return []
func changesmade(_change=0):
	emit_signal("changesmade")

func update_Morph(list):
	$'%Morph'.OptionItems =list
	$'%Morph'._ready()
