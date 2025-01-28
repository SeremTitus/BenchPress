extends ActionRegister


const AddClipboard = preload("res://src/core/Actions/OS/AddClipboard.gd")
const GetClipboard = preload("res://src/core/Actions/OS/GetClipboard.gd")
const ClearClipboard = preload("res://src/core/Actions/OS/ClearClipboard.gd")
const GetTimeDate = preload("res://src/core/Actions/OS/GetTimeDate.gd")
const Lock = preload("res://src/core/Actions/OS/lock.gd")
const Reboot = preload("res://src/core/Actions/OS/reboot.gd")
const Shutdown = preload("res://src/core/Actions/OS/Shutdown.gd")

func _init() -> void:
	add(AddClipboard.new())
	add(GetClipboard.new())
	add(ClearClipboard.new())
	add(GetTimeDate.new())
	add(Lock.new())
	add(Reboot.new())
	add(Shutdown.new())
