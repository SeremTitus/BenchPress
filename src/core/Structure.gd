class_name Structure extends RefCounted

var title: StringName #eg ADD VARIABLE
var library_name:StringName #eg Built-in
var description: String
var icon: Texture2D
var group_path: String
var py_include:PackedStringArray# complies to importes
var file_include:Array[PyScript]# complies to a create a file that is imported
var structure_include:Array[Structure] # also compiled
var holds_child_element: bool = false # called in a if statement return true or fasle 
var code: String # complies to a function
var properties:Array[Attribute]# complies to a function args
var output_properties:Array[Attribute]#Always Attribute.type = types.Text
