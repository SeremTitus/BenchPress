extends PanelContainer

@onready var tree:TrueTree = %TrueTree

func _ready():
	GlobalLibrary.library_updated.connect(populate_tree)
	populate_tree()
	
func populate_tree() -> void:
	tree.remove_all_clildren()
	var library = GlobalLibrary.get_sorted(GlobalLibrary.SortMode.None)
	for structure:Structure in library:
		var item:CustomStructureItem = CustomStructureItem.create(
			structure.title,
			structure,
			tree,
			structure.icon
			)
		tree.add_item(item,structure.group_path)
