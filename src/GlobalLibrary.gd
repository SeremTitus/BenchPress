extends Node

signal library_updated

var library:Array[Structure]
var library_folder_path:PackedStringArray = ["res://src/core/benchpress_libraries/"]
enum SortMode{
	None = 0,
	NameAscending,
	NameDecending,
	GroupAscending,
	GroupDecending,
}
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
		library.append(benchpress.library)
	library_updated.emit()

func get_sorted(select_sort:SortMode) -> Array[Structure]:
	if select_sort == SortMode.None: return library
	var new_array:Array[Structure] = library.duplicate()
	var sorting:Callable = func(a:Structure, b:Structure) -> bool:
		var string_compare:Callable = func(ax:String, bx:String) -> bool:
			var  to_sort:Array = [ax,bx]
			to_sort.sort()
			return to_sort[0] == bx
		var return_value:bool = false
		match select_sort:
			SortMode.GroupAscending:
				if string_compare.call(a.group_path, b.group_path):
					return_value = true
			SortMode.GroupDecending:
				if not string_compare.call(a.group_path, b.group_path):
					return_value = true
			SortMode.NameAscending:
				if string_compare.call(a.group_path+"/"+a.title,b.group_path+"/"+b.title):
					return_value = true
			SortMode.NameDecending:
				if not string_compare.call(a.group_path+"/"+a.title,b.group_path+"/"+b.title):
					return_value = true
		return return_value
	new_array.sort_custom(sorting)
	return new_array
