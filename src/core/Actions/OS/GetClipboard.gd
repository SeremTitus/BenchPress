extends Action

func _init() -> void:
	title = "get_clipboard"
	imports.append("pyperclip")
	supported.append(Platforms.desk)
	global_properties.append(Attribute.new("text", Attribute.types.Text))
	code = "text = pyperclip.paste()"
