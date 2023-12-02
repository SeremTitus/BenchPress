class_name GlobalLibrary extends RefCounted

var library:Array[ElementStructure]
var external_library_file_path: Array[String] = []
var external_library_folder_path: Array[String] = []

func _init(benchpress_to_include:Array[Benchpress] = []):
	for folder_path in external_library_folder_path:
		var dir = DirAccess.open(folder_path)
		if dir:
			dir.list_dir_begin()
			var file_name = dir.get_next()
			var file_extension = file_name.get_extension().to_lower()
			while file_extension != "benchpress":
				if not dir.current_is_dir():
					var file_path = dir.get_current_dir +"/"+ file_name
					external_library_file_path.append(file_path)
			file_name = dir.get_next()
	for file_path in external_library_file_path:
		benchpress_to_include.append(Benchpress.new(file_path))
	update_library(benchpress_to_include)

func update_library(benchpress_to_include:Array[Benchpress] = []):
	for benchpress in benchpress_to_include:
		library.append(benchpress.library)
