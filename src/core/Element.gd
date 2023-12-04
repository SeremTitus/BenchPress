class_name Element extends RefCounted

signal element_properties_changed

var owner:Element
var properties:Array[Attribute]
var structure:ElementStructure
var is_enabled:bool = true
var children_element:Array[Element] = []
var graph_position:Vector2
var references:UniqueReference

func emit_attribute_changed():
	element_properties_changed.emit()

func add_property(new_attribute:Attribute):
	new_attribute.attribute_value_changed.connect(emit_attribute_changed)
	properties.append(new_attribute)

func get_child_count() -> int:
	var count = children_element.size()
	for child in children_element:
		count += child.get_child_count()
	return count

func add_chirdren(children:Array[Element],to:Element) -> void:
	for child in children:
		child.owner = to
		to.append(child)

func delete_chirdren(children:Array[Element]) -> void:
	for child in children:
		var child_pos:int = child.owner.children_element.find(child)
		child.owner.children_element.pop_at(child_pos)

func move_chirdren(children:Array[Element],to:Element,pos:int = -1) -> void:
	var shift :int = 0
	for child in children:
		var child_pos:int = child.owner.children_element.find(child)
		child.owner.children_element.pop_at(child_pos)
		child.owner = to
		if pos > -1:
			to.children_element.append(child)
		else:
			to.children_element.insert(pos+shift,child)
		shift += 1
