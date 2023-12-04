class_name Attribute extends RefCounted

signal attribute_value_changed

enum types {
	None = 0,
	Bool,
	Number,
	Enum,
	Text,
	LongText,
	Mail,
	OSPath,
	List,
	Table,
	dictionary,
	image,
	Document,
	UISelectorWeb,
	UISelectorApp,
	UISelectorAndroid
}

var original_name:StringName = &""
var unique_name:StringName = &""
var value:Variant:set = set_value
var default_value:Variant
var type:types = types.None

var references:Unique
var profile:String

func set_value(new_value) -> void:
	value = new_value
	attribute_value_changed.emit()

func  reset_value() -> void:
	set_value(default_value)

func  align(new_references:Unique, profile_name:String) -> void:
	references = new_references
	profile = profile_name
	unique_name = new_references.assign_guided(original_name,profile)

func  unique_rename(new_name:String) -> void:
	if not references == null:
		references.unassign(unique_name,profile)
		new_name = references.assign_guided(new_name,profile)
	unique_name = new_name
