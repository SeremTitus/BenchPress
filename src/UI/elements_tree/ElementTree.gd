extends PanelContainer

@export var sort_type:GlobalLibrary.SortMode = GlobalLibrary.SortMode.None

@onready var tree:TrueTree = %TrueTree

func _ready():
	GlobalLibrary.library_updated.connect(populate_tree)
	populate_tree()
	
func populate_tree(library:Array[Structure] = GlobalLibrary.get_sorted(sort_type)) -> void:
	tree.remove_all_clildren()
	for structure:Structure in library:
		var item:CustomStructureItem = CustomStructureItem.create(
			structure.title,
			structure,
			tree,
			structure.icon
			)
		tree.add_item(item,structure.group_path)

func search_tree(search:String) -> void:
	if search.is_empty():
		populate_tree()
	else:
		populate_tree(GlobalLibrary.get_search(search,sort_type))
