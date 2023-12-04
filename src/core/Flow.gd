class_name Flow extends Element

var title: StringName
var orphan_elements:Array[Element] = []

func _init(new_title:StringName) -> void:
	rename_flow(new_title)

func emit_flow_element_attribute_changed():
	pass

func rename_flow(new_title:StringName) -> void:
	title = new_title

func add_orphan_child(children:Array[Element]) -> void:
	for child in children:
		if child in self.orphan_elements:
			continue
		if child.owner == null:
			var child_pos = child.owner.children_element.find(child)
			child.owner.children_element.pop_at(child_pos)
		child.owner = self
		self.orphan_elements.append(child)

func reparent_orphan_child(children:Array[Element],to:Element,pos:int = -1)\
	 -> void:
	var shift :int = 0
	for child in children:
		if child == null:
			return
		var child_pos:int = child.owner.orphan_elements.find(child)
		child.owner.orphan_elements.pop_at(child_pos)
		child.owner = to
		if pos > -1:
			to.children_element.append(child)
		else:
			to.children_element.insert(pos+shift,child)
		shift += 1

func find_child(child_name:StringName,start_at:Element = self) -> Element:
	var found:Element
	for child in start_at.children_element:
		if child.unique_name == child_name:
			return child
	for child in start_at.children_element:
		found = find_child(child_name,child)
		if not found == null:
			return found
	if start_at is Flow:
		for child in start_at.orphan_elements:
			if child.unique_name == child_name:
				return child
			else:
				found = find_child(child_name,child)
				if not found == null:
					return found
	return found

func get_child_count() -> int:
	var count = super()
	count += orphan_elements.size()
	for child in orphan_elements:
		count += child.get_child_count()
	return count
