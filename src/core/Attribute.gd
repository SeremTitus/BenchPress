class_name Attribute extends RefCounted

signal attribute_value_changed(new_value:Variant)
signal attribute_const_changed_attempt(attribute:Attribute,new_value:Variant)

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
var value:Variant:set = set_value, get = get_value
var default_value:Variant
var type:types = types.None
var is_const = false

var references:Unique
var profile:String

func set_value(new_value:Variant) -> void:
	if new_value is String:
		if new_value[0] == '"':
			new_value = new_value.erase(0)
		if new_value[len(new_value) - 1] == '"':
			new_value = new_value.erase(len(new_value) - 1)
	if is_const:
		attribute_const_changed_attempt.emit(self,new_value)
		return
	value = new_value
	attribute_value_changed.emit(value)

func get_value() -> Variant:
	match type:
		types.Text, types.LongText, types.OSPath:
			return '"' + str(value) + '"'
	return value

func  reset_value() -> void:
	set_value(default_value)

func ensure_global() -> void:
	if unique_name.is_empty():
		unique_name = original_name
		if references and profile:
			align(references,profile)

func  align(new_references:Unique, profile_name:String) -> void:
	references = new_references
	profile = profile_name
	unique_name = new_references.assign_guided(original_name,profile)

func  unique_rename(new_name:String) -> void:
	if not references:
		references.unassign(unique_name,profile)
		new_name = references.assign_guided(new_name,profile)
	unique_name = new_name
