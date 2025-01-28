extends Node

var current_project:Benchpress = Benchpress.new()

func open_file(file_path:String) -> Error:
	# Test if file exists
	var file:FileAccess = FileAccess.open(file_path,FileAccess.READ)
	var err:Error = FileAccess.get_open_error()
	if file:
		err = OK
		file.close()
		current_project = Benchpress.new(file_path)
	return err

func new(file_path:String) -> void:
	current_project = Benchpress.new(file_path)
