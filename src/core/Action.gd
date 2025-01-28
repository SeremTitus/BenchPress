## a strucure consider it as a function contructor that can be called [ActionCall]
class_name Action extends RefCounted

enum  Platforms {
	Win,
	mac,
	tux, ## linux
	desk, ## desktop platform
	droid, ## android
	all, ## all available platforms
}

var title: StringName #eg add_variable -> ADD VARIABLE
var library_name: StringName = 'built_in'
var description: String
var icon: Texture2D
var group_path: String
##Supported Platforms
var supported: Array[Platforms]
## Complies to importes
var imports: PackedStringArray
## Also compiled
var Action_include: Array[Action]
##  Action calls. insert with #call_id for py
var inter_struture_calls: Dictionary[int, ActionCall] # call_id, Call
## Called in a if statement return true or fasle
var holds_children := false
## Holds_children must be true called in a while statement return true or fasle
var loop_determiner := false
## Complies to a py function body
var code: String
## Complies to a function args
var properties: Array[Attribute]
## Properties accessible by all ActionCall and Actions, use _init to set if [is_in_gd] is true.
var global_properties: Array[Attribute] # Always Attribute.type = types.Text
## Strucure can code can be in GdScript or Python
# TODO: Setup bidirectional call between strucures reguardless of language
var is_in_gd := false

## last args global_output = ["var_name", "var_name2"]
func code_to_parser(inter_calls: Dictionary[int, String] = {}) -> String:
	if code.is_empty():
		return ""
	var source: String = code
	var count:int = 0
	for attribute in global_properties:
		source = source.replacen(attribute.original_name, "globals()[global_output[" + str(count) + "]]")
		count += 1
	
	for call_id in inter_calls:
		#TODO: ensure indenting match
		source = source.replacen("#" + str(call_id), inter_calls[call_id])
	return source

func gd_execute(_global: Array[Attribute]) -> Error:
	return OK
