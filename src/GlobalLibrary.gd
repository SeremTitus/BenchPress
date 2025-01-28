extends Node

signal library_updated

var library: Array[Action]
var library_folder_path: PackedStringArray = ["res://src/core/benchpress_libraries/"]

func _init() -> void:
	var benchpress_to_include:Array[Benchpress] = []
	var external_library_file_path:PackedStringArray = []
	for folder_path in library_folder_path:
		var dir = DirAccess.open(folder_path)
		if dir:
			var file_name = dir.get_next()
			var file_extension = file_name.get_extension().to_lower()
			if not dir.current_is_dir() and file_extension == "benchpress":
				var file_path = dir.get_current_dir +"/"+ file_name
				external_library_file_path.append(file_path)
			file_name = dir.get_next()
	for file_path in external_library_file_path:
		benchpress_to_include.append(Benchpress.new(file_path))
	update_library(benchpress_to_include)

func update_library(benchpress_to_include:Array[Benchpress] = []) -> void:
	for benchpress in benchpress_to_include:
		for Action in benchpress.library:
			if not Action in library:
				library.append(Action)
	library_updated.emit()
