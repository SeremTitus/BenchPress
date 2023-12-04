class_name Benchpress extends RefCounted

var file_path:String = ""
var project_name:String = ""
var benchpress_version:String = "1"
var globals:Array[Attribute]
var element_globals:Array[Attribute]
var main_flow = Flow.new("Main")
var flows: Array[Flow] = [main_flow]
var library:Array[Structure]
var schedules: Array[Schedule]
var remote_devices: Array
## profiles -> flow_name, globals_name
var references:Unique = Unique.new()


func _init(new_file_path:String = "",load:bool = true) -> void:
	file_path = new_file_path
	if load:
		load_from()

func create_new_flow(unique_name:String) -> Flow:
	var new_flow = Flow.new(unique_name)
	flows.append(new_flow)
	return new_flow

func  add_flow(new_flow:Flow) -> void:
	flows.append(new_flow)

func delete_flow(flow:Flow) -> void:
	if main_flow == flow:
		return
	var flow_pos = flows.find(flow)
	flows.pop_at(flow_pos)

#region save and load
func save():
	var save_load = SaveLoad.new()
	save_load.add_include_property_name(self,"benchpress_version")
	save_load.save_to(file_path,self)

func save_as(save_file_path:String):
	file_path = save_file_path
	save()

func load_from(load_file_path:String = file_path):
	var save_load = SaveLoad.new()
	save_load.load_from(load_file_path,self)
#endregion
