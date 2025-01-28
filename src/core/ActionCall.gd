class_name ActionCall extends RefCounted

signal action_call_parameter_changed

var owner: ActionCall
## considered as inputs
var properties: Array[Attribute]
## considered as ouputs
var global_properties: Array[Attribute]
var action: Action
## indicate weather it will compile
var is_enabled: bool = true
var children_action_call: Array[ActionCall] = []
# TODO: this is for graph view.
var graph_position: Vector2

var references: Unique

func _init(from_action:Action) -> void:
	if not from_action:
		return
	action = from_action
	# Duplicated to avoid changing base from from_Action
	properties = Duplicate.variable(from_action.properties) as Array[Attribute]
	global_properties = Duplicate.variable(from_action.global_properties) as Array[Attribute]
	for attribute in properties:
		attribute.attribute_value_changed.connect(emit_attribute_changed.unbind(1))
		attribute.attribute_const_changed_attempt.connect(attribute_changed_attempt)

func get_all_action_call_globals() -> Array[Attribute]:
	var globals: Array[Attribute]
	globals.append_array(global_properties)
	for child in children_action_call:
		globals.append_array(child.get_all_action_call_globals())
	return globals

func create_child_action_call(from_Action: Action) -> ActionCall:
	var new_action_call := ActionCall.new(from_Action)
	new_action_call.owner = self
	children_action_call.append(new_action_call)
	return new_action_call

func emit_attribute_changed() -> void:
	action_call_parameter_changed.emit()

func attribute_changed_attempt(attribute: Attribute,new_value:Variant) -> void:
	var new_attribute: Attribute = Duplicate.object(attribute)
	new_attribute.is_const  = false
	new_attribute.value = new_value
	if properties.has(attribute):
		properties.append(new_attribute)
		properties.erase(attribute)


func add_property(new_attribute: Attribute):
	new_attribute.attribute_value_changed.connect(emit_attribute_changed)
	properties.append(new_attribute)

func get_child_count() -> int:
	var count = children_action_call.size()
	for child in children_action_call:
		count += child.get_child_count()
	return count

func add_chidren(children: Array[ActionCall], to: ActionCall = self) -> void:
	for child in children:
		child.owner = to
		to.children_action_call.append(child)

func delete_chidren(children: Array[ActionCall]) -> void:
	for child in children:
		var child_pos: int = child.owner.children_action_call.find(child)
		child.owner.children_action_call.pop_at(child_pos)

func move_chidren(children: Array[ActionCall], to: ActionCall, pos: int = -1) -> void:
	var shift: int = 0
	for child in children:
		var child_pos: int = child.owner.children_action_call.find(child)
		child.owner.children_action_call.pop_at(child_pos)
		child.owner = to
		if pos > -1:
			to.children_action_call.append(child)
		else:
			to.children_action_call.insert(pos+shift,child)
		shift += 1
