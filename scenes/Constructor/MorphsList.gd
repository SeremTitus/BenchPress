extends Node

onready var morph_temp = preload("res://scenes/Constructor/morph_template.tscn")
onready var code_temp = preload("res://scenes/Constructor/code_template.tscn")
onready var pyEditor =$"%PyEditor"

func _on_Add_button_down():
	var code = code_temp.instantiate()
	var morph = morph_temp.instantiate()
	morph.connect("morph_renamed",code,"renamed")
	morph.connect("morph_freed",code,"freed")
	morph.connect("changesmade",$"../../../../../../../../../../../..",'changesmade')
	
	code.connect("emit_code",morph,"set_code")
	pyEditor.add_child(code,true)
	add_child(morph)
	




