extends Action

func _init() -> void:
	title = "get_timedate"
	imports.append("datetime")
	supported.append(Platforms.desk)
	global_properties.append(Attribute.new("datetime", Attribute.types.Text))
	code = "datetime = datetime.datetime.now()"
