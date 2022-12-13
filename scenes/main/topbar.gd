extends Control


onready var file = $"%file"
onready var edit = $"%edit"
onready var debug = $"%debug"
onready var editor = $"%editor"
onready var help = $"%help"
onready var device = $"%device"


func _ready():
	file_item()
	edit_item()
	debug_item()
	editor_item()
	help_item()
	device_item()
	
func file_item():
	file.get_popup().add_item("New")
	file.get_popup().add_item("Open")
	file.get_popup().add_item("Save")
	file.get_popup().add_item("Append")
	file.get_popup().add_item("Export")
	file.get_popup().add_item("Quit")
	
func edit_item():
	edit.get_popup().add_item("Undo")
	edit.get_popup().add_item("Redo")
	edit.get_popup().add_item("Fild")
	edit.get_popup().add_item("Rename")
	edit.get_popup().add_item("Cut")
	edit.get_popup().add_item("Copy")
	edit.get_popup().add_item("Paste")
	edit.get_popup().add_item("Select All")
	edit.get_popup().add_item("Inverse Selection")
	edit.get_popup().add_item("Clear Selection")
	
	
func debug_item():
		debug.get_popup().add_item("Select Device")
		debug.get_popup().add_item("Run")
		debug.get_popup().add_item("Run by Step")
		debug.get_popup().add_item("Pause")
		debug.get_popup().add_item("Continue")
		debug.get_popup().add_item("Stop")
		debug.get_popup().add_item("Rerun")
		debug.get_popup().add_item("Record")
		debug.get_popup().add_item("Skip Breakpoints")
		debug.get_popup().add_item("Skip Into")
		
func editor_item():
	editor.get_popup().add_item("Editor Settings")
	editor.get_popup().add_item("Editor Layout")
	editor.get_popup().add_item("Open Editor Data")
	editor.get_popup().add_item("Manage Editor Feature")
	editor.get_popup().add_item("Manage Editor Extensions")

func help_item():
	help.get_popup().add_item("Documentation")
	help.get_popup().add_item("Report a Bug")
	help.get_popup().add_item("About BenchPress")
	help.get_popup().add_item("Support Development")
	
func device_item():
	device.get_popup().add_radio_check_item("Local")
	device.get_popup().set_item_disabled(0,true)
	
