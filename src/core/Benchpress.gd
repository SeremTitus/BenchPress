class_name Benchpress extends RefCounted

var file_path: String = ""
var project_name: String = ""
var benchpress_version: String = "1"
var globals: Array[Attribute]
var main_subroutine := Subroutine.new("Main")
var subroutines: Array[Subroutine] = [main_subroutine]
var library: Array[Action] # TODO
var schedules: Array[Schedule] # TODO
var remote_devices: Array # TODO
## profiles -> subroutine_name, globals_name
var references: Unique = Unique.new()


func _init(new_file_path: String = "",do_load: bool = true) -> void:
	file_path = new_file_path
	if do_load and !file_path.is_empty():
		load_from()

func get_all_ActionCall_globals() -> Array[Attribute]:
	var globals: Array[Attribute]
	for subroutine in subroutines:
		globals.append_array(subroutine.get_all_action_call_globals())
	return globals

func create_new_Subroutine(unique_name: String = "Untitiled") -> Subroutine:
	unique_name = references.assign_guided(unique_name,"subroutine_name")
	var new_Subroutine = Subroutine.new(unique_name)
	subroutines.append(new_Subroutine)
	return new_Subroutine

func add_Subroutine(new_Subroutine: Subroutine) -> String:
	var unique_name = references.assign_guided(new_Subroutine.title,"subroutine_name")
	new_Subroutine.title = unique_name
	subroutines.append(new_Subroutine)
	return unique_name

func delete_Subroutine(subroutine: Subroutine) -> void:
	if main_subroutine == Subroutine:
		return
	references.unassign(subroutine.title,"subroutine_name")
	var subroutine_pos = subroutines.find(Subroutine)
	subroutines.pop_at(subroutine_pos)

func  delete_Subroutine_by_name(unique_name: String) -> void:
	var subroutine: Subroutine = find_Subroutine(unique_name)
	delete_Subroutine(subroutine)

func  find_Subroutine(unique_name: String) -> Subroutine:
	for subroutine in subroutines:
		if subroutine.title == unique_name:
			return subroutine
	return null

func rename_Subroutine(current_name:String, new_name:String) -> String:
	var subroutine = find_Subroutine(current_name)
	if subroutine:
		references.unassign(current_name,"subroutine_name")
		new_name = references.assign_guided(new_name,"subroutine_name")
		subroutine.title = new_name
	return new_name

#region save and load
func save() -> Error:
	var save_load := SaveLoad.new()
	save_load.add_include_property_name(self,"benchpress_version")
	#return save_load.save_to(file_path,self)
	return OK

func save_as(save_file_path:String) -> Error:
	file_path = save_file_path
	return save()

func load_from(load_file_path:String = file_path):
	var save_load := SaveLoad.new()
	save_load.load_from(load_file_path,self)
#endregion
