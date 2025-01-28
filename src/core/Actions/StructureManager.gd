class_name ActionManager extends ActionRegister #Sigtones

const OsActionRegister = preload("res://src/core/Actions/OS/OsActionRegister.gd")

func _init() -> void:
	add_reg(OsActionRegister.new())
	
