extends TextureRect

signal Texture_Changed
onready var iconfile = $"%iconFileDialog"

func _on_iconFileDialog_file_selected(path):
	var img = Image.new()
	var tex = ImageTexture.new()
	img.load(path)
	tex.set_storage(1) 
	tex.create_from_image(img)
	texture=tex
	emit_signal("Texture_Changed")

func _on_add_button_down():
	iconfile.popup()
	
func _on_remove_button_down():
	texture = ImageTexture.new()
	emit_signal("Texture_Changed")
