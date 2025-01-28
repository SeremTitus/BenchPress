extends Action

func _init() -> void:
	title = "clear_clipboard"
	imports.append("pyperclip")
	supported.append(Platforms.desk)
	code = "pyperclip.copy('')"
