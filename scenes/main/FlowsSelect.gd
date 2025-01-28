extends Control


@onready var Subroutinename = preload("res://scenes/main/SubroutineSelectName.tscn")
var content
func _ready():
	# warning-ignore:return_value_discarded
	#Global.connect("current_Project_changed",generate_Subroutine_select_list)
	generate_Subroutine_select_list()
	
func generate_Subroutine_select_list(current_project ={}):
	for child in $"%Content".get_children():
		child.queue_free()
	#var SubroutineNames = current_project.Subroutines.keys()
	#for i in SubroutineNames:
	#	var newSubroutine = Subroutinename.instantiate()
	#	newSubroutine.Subroutinename = i
	#	$"%Content".add_child(newSubroutine)

func _on_Button_pressed():
	var newSubroutine ='untitled'
	#newSubroutine = Global.unique_name(Global.current_project.Subroutines.keys(),newSubroutine)
	#Global.add_NewSubroutine(newSubroutine)
