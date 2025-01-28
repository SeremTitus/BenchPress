class_name TrueTree extends VBoxContainer

@export var column:int = 0 : set = set_column
@export var is_root_hiden:bool = false : set = set_root_hiden
@export var use_tree_path:bool  = true
@export var draged_persist_child:bool = true

var persist_child:bool = false
var is_collapse:bool = false
var tree_name:String = "" : set = set_text

var child_container:VBoxContainer = VBoxContainer.new()
var scroll_container:ScrollContainer = ScrollContainer.new()
var margin_container:MarginContainer = MarginContainer.new()
var collapse_toggle:HBoxContainer = HBoxContainer.new()
var collapse_toggle_icon:TextureRect = TextureRect.new()
var custom_icon:TextureRect = TextureRect.new()
var label:Label = Label.new()
var arrow_down = preload("res://assets/icons/arrow_down.svg")
var arrow_right = preload("res://assets/icons/arrow_right.svg")

func set_column(new_value:int) -> void:
	column = new_value if new_value > 0 else 0
	margin_container.add_theme_constant_override("margin_left", 8 * column)
	for child in child_container.get_children():
		if child is TrueTree:
			child.set_column(column + 1)

func set_root_hiden(new_value:bool) -> void:
	is_root_hiden = new_value
	collapse_toggle.visible = not is_root_hiden
	for child in child_container.get_children():
		if child is TrueTree:
			if is_root_hiden:
				child.set_column(column)
			else:
				child.set_column(column + 1)

func set_text(text:String) -> void:
	label.text = text
	tree_name = text

func _init(is_child:bool = false,column_num:int = 0) -> void:
	column = column_num
	collapse_toggle.gui_input.connect(collapse_toggle_input)
	collapse_toggle.add_child(collapse_toggle_icon)
	custom_icon.visible = false
	collapse_toggle.add_child(custom_icon)
	collapse_toggle.add_child(label)
	add_item(collapse_toggle)
	scroll_container.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	margin_container.set_h_size_flags(Control.SIZE_EXPAND_FILL)
	margin_container.add_child(child_container)
	if is_child:
		set_text("root")
		add_child(margin_container,false,Node.INTERNAL_MODE_BACK)
	else:
		scroll_container.add_child(margin_container)
		add_child(scroll_container,false,Node.INTERNAL_MODE_BACK)
	child_container.child_entered_tree.connect(collapse_toggle_icon_visibilty.unbind(1))
	child_container.child_exiting_tree.connect(check_for_persistance)
	collapse_toggle_icon_visibilty()

func  set_custom_icon(texture:Texture) -> void:
	custom_icon.texture = texture
	custom_icon.visible = true

func add_item(item:Control,tree_path:String = ""):
	item.visible = not is_collapse
	var tree:TrueTree = self
	if not tree_path.is_empty():
		var save_state = use_tree_path
		use_tree_path = true
		tree = create_subtree(tree_path)
		use_tree_path = save_state
	tree.child_container.add_child(item)

func  create_subtree(tree_path:String = "") -> TrueTree:
	var sub_tree:TrueTree = find_subtree_path(tree_path)
	if use_tree_path:
		if sub_tree: return sub_tree
		var path:Array = tree_path.split("/")
		var search_tree_name:String = path.pop_front()
		sub_tree = find_subtree_name(search_tree_name)
		if sub_tree:
			for str_name in path:
				sub_tree = sub_tree.create_subtree(str_name)
		else:
			sub_tree = TrueTree.new(true)
			sub_tree.set_text(search_tree_name)
			sub_tree.column = column + 1
			add_item(sub_tree)
	else:
		sub_tree = TrueTree.new(true)
		sub_tree.column = column + 1
		add_item(sub_tree)
	return sub_tree

func find_subtree_path(search_tree_path:String) -> TrueTree:
	if search_tree_path.is_empty(): return null
	var path:Array = search_tree_path.split("/")
	var search_tree_name:String = path.pop_front()
	var search_tree:TrueTree = find_subtree_name(search_tree_name)
	if search_tree:
		for str_name in path:
			search_tree = search_tree.find_subtree_name(str_name)
			if not search_tree:
				return search_tree
	return search_tree

func find_subtree_name(search_tree_name:String) -> TrueTree:
	if search_tree_name.is_empty(): return null
	for child in child_container.get_children():
		if child == collapse_toggle: continue
		if child is TrueTree and child.tree_name == search_tree_name:
			return child
	return null

func collapse_toggle_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT\
		and event.pressed:
		if is_collapse:
			uncollapse()
		else:
			collapse()

func collapse(recusive:bool = false) -> void:
	for child in child_container.get_children():
		if child == collapse_toggle: continue
		child.visible = false
		if recusive and child is TrueTree:
			child.collapse(true)
	is_collapse = true
	collapse_toggle_icon_visibilty()

func uncollapse(recusive:bool = false) -> void:
	for child in child_container.get_children():
		if child == collapse_toggle: continue
		child.visible = true
		if recusive and child is TrueTree:
			child.uncollapse(true)
	is_collapse = false
	collapse_toggle_icon_visibilty()

func collapse_toggle_icon_visibilty() -> void:
	if tree_child_count() > 0:
		if is_collapse:
			collapse_toggle_icon.texture = arrow_right
		else:
			collapse_toggle_icon.texture = arrow_down
	else:
		var new_image:Image = Image.create(16,16,false,Image.FORMAT_RGBA8)
		var new_texture:ImageTexture = ImageTexture.create_from_image(new_image)
		collapse_toggle_icon.texture = new_texture

func tree_child_count() -> int:
	return child_container.get_child_count() - 1

func remove_all_clildren() -> void:
	var save_state = persist_child
	persist_child = false
	for child in child_container.get_children():
		if child == collapse_toggle: continue
		child_container.remove_child(child)
	persist_child = save_state
	collapse_toggle_icon_visibilty()

func remove_empty_subtrees(recusive:bool = true) -> void:
	var save_state = persist_child
	persist_child = false
	for child in child_container.get_children():
		if child is TrueTree:
			if recusive:
				child.remove_empty_subtrees(recusive)
			if not child.tree_child_count()  > 0:
				child_container.remove_child(child)
	persist_child = save_state
	collapse_toggle_icon_visibilty()

## if object is sucessfully drag and droped from tree, a copy replaces it
func check_for_persistance(item:Node) -> void:
	if persist_child:
		print(child_container.is_queued_for_deletion())
		var idx = item.get_index()
		var replacement = Duplicate.object(item)
		add_item(replacement)
		child_container.move_child(replacement,idx)
	collapse_toggle_icon_visibilty()

func  _notification(what):
	if what == NOTIFICATION_DRAG_BEGIN:
		if draged_persist_child:
			persist_child = true
	elif what == NOTIFICATION_DRAG_END:
		if draged_persist_child:
			persist_child = false
