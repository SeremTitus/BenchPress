extends Control
signal emit_code
func renamed(text):
	name = text
func freed():
	queue_free()

func _on_code_text_changed():
	emit_signal("emit_code",$'code'.text)
