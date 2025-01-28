extends HBoxContainer


const ActionCall_container = preload("res://src/UI/Subroutine_container/ActionCallContainer.gd")
const custom_tab = preload("res://src/UI/Subroutine_container/custom_tab.tscn")

func  _ready() -> void:
	var Subroutine:Subroutine = Opened.current_project.main_Subroutine
	open_Subroutine(Subroutine)

func _on_add_button_down() -> void:
	var Subroutine:Subroutine = Opened.current_project.create_new_Subroutine()
	open_Subroutine(Subroutine)

func  open_Subroutine(Subroutine:Subroutine) -> void:
	var new_ActionCall_container:Node = ActionCall_container.new()
	new_ActionCall_container.set_Subroutine(Subroutine)
	%Containers.add_child(new_ActionCall_container)
	var new_custom_tab:Node = custom_tab.instantiate()
	new_custom_tab.set_text(Subroutine.title)
	%TabContainer.add_child(new_custom_tab)
