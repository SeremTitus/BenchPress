extends Control

@onready var Properties = $"%Properties"

func _ready():
	get_tree().get_root().set_flag(Window.FLAG_BORDERLESS,false)
	ProjectSettings.set_setting("display/window/size/borderless",false)
	ProjectSettings.connect("project_settings_changed",update_from_settings)

func update_from_settings():
	$"%Dock".set_control_hidden($"%Properties",not ProjectSettings.get_setting('benchpress/properties/dock_visible'))
