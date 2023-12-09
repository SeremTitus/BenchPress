class_name Element extends RefCounted

signal element_properties_changed

var owner:Element
var properties:Array[Attribute]
var global_properties:Array[Attribute]
var structure:Structure
var is_enabled:bool = true
var children_element:Array[Element] = []
var graph_position:Vector2
var references:Unique

func _init(new_structure:Structure) -> void:
	structure = new_structure
	properties = new_structure.properties
	global_properties = new_structure.global_properties
	for attribute in properties:
		attribute.attribute_value_changed.connect(emit_attribute_changed.unbind(1))
		attribute.attribute_const_changed_attempt.connect(attribute_changed_attempt)
	for attribute in global_properties:
		attribute.attribute_value_changed.connect(emit_attribute_changed.unbind(1))
		attribute.attribute_const_changed_attempt.connect(attribute_changed_attempt)
	
func emit_attribute_changed() -> void:
	element_properties_changed.emit()

func attribute_changed_attempt(attribute:Attribute,new_value:Variant) -> void:
	var new_attribute:Attribute = Duplicate.object(attribute)
	new_attribute.is_const  = false
	new_attribute.value = new_value
	if properties.has(attribute):
		properties.append(new_attribute)
		properties.erase(attribute)
	
	
func add_property(new_attribute:Attribute):
	new_attribute.attribute_value_changed.connect(emit_attribute_changed)
	properties.append(new_attribute)

func get_child_count() -> int:
	var count = children_element.size()
	for child in children_element:
		count += child.get_child_count()
	return count

func add_chidren(children:Array[Element],to:Element = self) -> void:
	for child in children:
		child.owner = to
		to.children_element.append(child)

func delete_chidren(children:Array[Element]) -> void:
	for child in children:
		var child_pos:int = child.owner.children_element.find(child)
		child.owner.children_element.pop_at(child_pos)

func move_chidren(children:Array[Element],to:Element,pos:int = -1) -> void:
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
