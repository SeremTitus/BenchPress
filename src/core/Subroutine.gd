class_name Subroutine  extends ActionCall

var title: StringName
var orphan_ActionCalls: Array[ActionCall] = []

func _init(new_title: StringName) -> void:
	rename_subroutine(new_title)

func emit_subroutine_action_call_attribute_changed():
	pass

func rename_subroutine(new_title: StringName) -> void:
	title = new_title

func add_orphan_child(children: Array[ActionCall]) -> void:
	for child in children:
		if child in self.orphan_ActionCalls:
			continue
		if child.owner:
			var child_pos = child.owner.children_ActionCall.find(child)
			child.owner.children_ActionCall.pop_at(child_pos)
		child.owner = self
		self.orphan_ActionCalls.append(child)

func reparent_orphan_child(children: Array[ActionCall], to: ActionCall, pos: int = -1) -> void:
	var shift :int = 0
	for child in children:
		if child:
			return
		var child_pos:int = child.owner.orphan_ActionCalls.find(child)
		child.owner.orphan_ActionCalls.pop_at(child_pos)
		child.owner = to
		if pos > -1:
			to.children_ActionCall.append(child)
		else:
			to.children_ActionCall.insert(pos+shift,child)
		shift += 1

func find_child(child_name: StringName, start_at: ActionCall = self) -> ActionCall:
	var found:ActionCall
	for child in start_at.children_ActionCall:
		if child.unique_name == child_name:
			return child
	for child in start_at.children_ActionCall:
		found = find_child(child_name,child)
		if not found:
			return found
	if start_at is Subroutine:
		for child in start_at.orphan_ActionCalls:
			if child.unique_name == child_name:
				return child
			else:
				found = find_child(child_name,child)
				if not found:
					return found
	return found

func get_child_count() -> int:
	var count = super()
	count += orphan_ActionCalls.size()
	for child in orphan_ActionCalls:
		count += child.get_child_count()
	return count
