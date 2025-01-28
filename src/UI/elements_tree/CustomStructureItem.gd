class_name CustomActionItem extends Button

signal double_clicked(stored_data:Variant)

var is_selected:bool = false
var store_data:Action
var group_name:String = "CustomActionItem"
var search_radius:Node

func  _init() -> void:
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	add_to_group(group_name,true)

static func create(new_text:String,data:Action = null,search:Node = null,new_icon:Texture = null) -> CustomActionItem:
	var new_item:CustomActionItem = CustomActionItem.new()
	new_item.set_text(new_text)
	new_item.set_store_data(data)
	new_item.set_search_radius(search)
	new_item.set_custom_icon(new_icon)
	return new_item

func set_icon(texture:Texture) -> void:
	icon = texture

func  set_store_data(new_data:Action)  -> void:
	store_data = new_data

func set_search_radius(search:Node) -> void:
	search_radius = search

func select() -> void:
	is_selected = true

func unselect() -> void:
	is_selected = false

func _gui_input(event:InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.double_click:
			double_clicked.emit(store_data)
		elif event.is_released():
			var scene_tree: SceneTree = get_tree()
			if scene_tree and not event.ctrl_pressed:
				scene_tree.call_group(group_name,"unselect")
			select()

func _get_drag_data(_at_position) -> Variant:
	var data:Array[Action] = []
	if store_data:
		data.append(store_data)
	if not search_radius and get_tree(): search_radius = get_tree().get_root()
	for item in get_items(search_radius):
		data.append(item.store_data)
	if data.is_empty(): return null
	return data

func get_items(search:Node) -> Array:
	if not search: return []
	var items:Array = []
	for child in search.get_children():
		if child.is_in_group(group_name):
			items.append(items)
		items.append_array(get_items(child))
	return items
