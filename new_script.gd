@tool
extends EditorScript
const Globaly = preload("res://src/core/Attribute.gd")

func _run() -> void:
	var y = GDScript.new()
	y.source_code="func _init():\n\tprint('hello')"
	var n = Node.new()
	if n is Variant: print("variant")
	
	
	
	
