extends Action

func _init() -> void:
	title = "add_to_clipboard"
	imports.append("pyperclip")
	supported.append(Platforms.desk)
	properties.append(Attribute.new("text", Attribute.types.Text))
	code = "pyperclip.copy(text)"
