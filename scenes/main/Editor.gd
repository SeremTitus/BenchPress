extends Control

@onready var Properties = $"%Properties"

func _ready():
	# warning-ignore:return_value_discarded
	ProjectSettings.connect("project_settings_changed",update_from_settings)

func update_from_settings():
	$"%Dock".set_control_hidden($"%Properties",not ProjectSettings.get_setting('benchpress/properties/dock_visible'))
	
