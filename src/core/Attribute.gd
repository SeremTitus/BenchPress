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
var value:Variant = null : set = set_value
var default_value:Variant = null
var type:types = types.None

func set_value(new_value):
	value = new_value
	attribute_value_changed.emit()

func  reset_value():
	set_value(default_value)
