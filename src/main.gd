extends Control

@export var desktop:PackedScene
@export var mobile:PackedScene

func _ready() -> void:
	if not Cli.run():
		get_tree().quit()
	var scene:Node
	if desktop:
		scene = desktop.instantiate()
	if OS.has_feature("mobile") or OS.has_feature("web_android") or\
	 	OS.has_feature("web_ios") and mobile:
		scene = mobile.instantiate()
	if scene:
		add_child(scene)
	else:
		get_tree().quit()
