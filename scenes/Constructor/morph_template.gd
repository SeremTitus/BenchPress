extends Node

signal morph_renamed
signal morph_freed
signal changesmade

var code =''
func _on_TextureRect_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed: 
		queue_free()
		emit_signal("morph_freed")
func _on_Morph_text_changed(new_text):
	emit_signal("morph_renamed",new_text)
	emit_signal("changesmade")
	
func get_morph_data():
	var data:Array =[]
	if $'MaxSizeContainer3/Morph'.text != '':
		data.append($'MaxSizeContainer3/Morph'.text)
		data.append($'MaxSizeContainer4/Feature'.text)
		data.append(code)
		return data
	else:
		return []
	
func set_code(text):
	code = text
	emit_signal("changesmade")
	
func _on_Feature_text_changed(_new_text):
	emit_signal("changesmade")
