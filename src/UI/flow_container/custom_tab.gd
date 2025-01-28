class_name CustomTab extends PanelContainer

@export var controls_to_this:Node

var text:String = "Main"
var edit_mode:bool = false :set = set_edit_mode
var select:bool = true
const group_name:String = "CustomTab"

@onready var icon = %Icon
@onready var line_edit = %LineEdit
@onready var close = %Close

func set_edit_mode(mode:bool) -> void:
	edit_mode = mode
	line_edit.editable = edit_mode

func set_select(mode:bool,persist_group:bool = true) -> void:
	var panel:StyleBoxFlat = StyleBoxFlat.new()
	panel.bg_color = Color("#1e1e1e")
	panel.border_color = Color("00fbf3")
	if mode and get_tree() and persist_group:
		get_tree().call_group(group_name,"set_select", false,false)
	if mode:
		if controls_to_this:
			controls_to_this.visible  = true
		panel.border_width_top = 3
		modulate = Color("ffffff")
		%Close.visible = true
	else:
		if controls_to_this:
			controls_to_this.visible = false
		panel.border_width_top = 0
		modulate = Color("ffffffb8")
		%Close.visible = false
	select = mode
	add_theme_stylebox_override("panel",panel)

func  _ready() -> void:
	add_to_group(group_name,true)
	set_select(true)

func set_text(new_text:String) -> void:
	text = new_text
	%LineEdit.text = text

func _on_line_edit_text_submitted(_new_text: String) -> void:
	edit_mode = false

func _on_line_edit_text_changed(new_text: String) -> void:
	var assigned_text = Opened.current_project.rename_Subroutine(text,new_text)
	text = assigned_text
	if assigned_text != new_text:
		%LineEdit.text = assigned_text

func  _input(event: InputEvent) -> void:
	if edit_mode and event is InputEventMouseButton and event.pressed:
		edit_mode = false

func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.double_click:
			edit_mode = true
		elif event.is_released():
			set_select(true)

func _on_line_edit_focus_exited() -> void:
	edit_mode = false

func _on_close_button_down() -> void:
	var parent:Node = get_parent()
	if parent and parent.get_child_count() > get_index() + 1 and parent.get_child(get_index() + 1 ) is CustomTab:
		parent.get_child(get_index() + 1 ).set_select(true)
	elif parent and get_index() > 0 and parent.get_child(get_index() - 1 ) is CustomTab:
		parent.get_child(get_index() - 1 ).set_select(true)
	if controls_to_this:
		controls_to_this.queue_free()
	self.queue_free()
