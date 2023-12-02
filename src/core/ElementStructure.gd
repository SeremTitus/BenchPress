class_name ElementStructure extends RefCounted

var title: StringName #eg ADD VARIABLE
var library_name:StringName #eg Built-in
var description: String
var icon: Texture2D
var group_path: String
var py_include:PackedStringArray
var structure_include:Array[ElementStructure]
var file_include:Array[PyScript]
var holds_child_element: bool = false
var code: String
var properties:Array[Attribute]
var output_properties:Array[Attribute]#Always Attribute.type = types.Text
