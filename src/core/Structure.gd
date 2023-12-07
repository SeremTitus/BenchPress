class_name Structure extends RefCounted

var title: StringName #eg add_variable -> ADD VARIABLE
var library_name:StringName #eg built_in
var description: String
var icon: Texture2D
var group_path: String
var imports:PackedStringArray# complies to importes
var file_include:Array[ExternalScript]# complies to a create a file that is imported
var structure_include:Array[Structure] # also compiled
var holds_child_element: bool = false # called in a if statement return true or fasle 
var code: String # complies to a function
var properties:Array[Attribute]# complies to a function args
var global_properties:Array[Attribute]#Always Attribute.type = types.Text

## last args global_output = ["var_name", "var_name2"]
func code_to_parser() -> String:
	if code.is_empty():
		return ""
	var source:String = code
	var count:int = 0
	for attribute in global_properties:
		source = source.replacen(attribute.original_name,\
				"globals()[global_output[" + str(count) + "]]")
		count += 1
	return source

