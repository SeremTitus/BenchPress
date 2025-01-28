extends PanelContainer

enum SortMode{
	None = 0,
	NameAscending,
	NameDecending,
	GroupAscending,
	GroupDecending,
}

@export var use_library_selection:bool = false
@export var sort_type:SortMode = SortMode.None
@onready var tree:TrueTree = %TrueTree
var global_library:Array[Action] = GlobalLibrary.library
var local_library:Array[Action] = Opened.current_project.library

var temp_prev_search:String
var temp_prev_search_results:Array[Action]

func set_use_library_selection(mode:bool) -> void:
	use_library_selection = mode
	%Library.visible = mode

func _ready():
	GlobalLibrary.library_updated.connect(update_global_library)
	set_use_library_selection(use_library_selection)
	update_library_selection()
	populate_tree(global_library + local_library)

func update_library_selection():
	var current_selection:int = %LibrarySelection.get_selected_id()
	%LibrarySelection.clear()
	%LibrarySelection.add_item("All")
	for item in get_library_name():
		%LibrarySelection.add_item(item)
	%LibrarySelection.selected = current_selection

func update_global_library():
	global_library = GlobalLibrary.library
	local_library = Opened.current_project.library
	update_library_selection()

func get_library_name() -> PackedStringArray:
	var library_names:PackedStringArray
	for Action in global_library + local_library:
		library_names.append(Action.library_name)
	return library_names

func populate_tree(library:Array[Action]) -> void:
	tree.remove_all_clildren()
	for Action:Action in library:
		var item:CustomActionItem = CustomActionItem.create(
			Action.title,
			Action,
			tree,
			Action.icon
			)
		tree.add_item(item,Action.group_path)

func search_tree(search:String) -> void:
	if search.is_empty():
		populate_tree(global_library + local_library)
		temp_prev_search  = ""
		temp_prev_search_results = []
	else:
		if temp_prev_search.is_empty() and search.is_subsequence_ofn(temp_prev_search):
			temp_prev_search_results = get_search(
				global_library + local_library,
				search,
				sort_type)
		else:
			temp_prev_search_results = get_search(
				temp_prev_search_results,
				search,
				sort_type)
		temp_prev_search = search
		populate_tree(temp_prev_search_results)

func get_selected_library() -> String:
	return %LibrarySelection.get_item_text(%LibrarySelection.get_selected_id())

func get_library_filter(library:Array[Action], filter:String = get_selected_library())\
	-> Array[Action]:
	if filter.is_empty() or filter == "All": return library
	var new_array:Array[Action] = library.duplicate()
	new_array.filter(func(Action:Action): return Action.library_name == filter)
	return new_array

func get_sorted(library:Array[Action],select_sort:SortMode) -> Array[Action]:
	if select_sort == SortMode.None: return get_library_filter(library)
	var new_array:Array[Action] = get_library_filter(library)
	var sorting:Callable = func(a:Action, b:Action) -> bool:
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

func get_search(library:Array[Action],search:String, select_sort:SortMode) -> Array[Action]:
	if search.is_empty(): return get_sorted(library,select_sort)
	var new_array:Array[Action] = get_sorted(library,select_sort)
	new_array = new_array.filter(func(Action:Action):
		return String(Action.group_path + "/" + Action.title)\
				.is_subsequence_ofn(search)
		)
	return new_array
