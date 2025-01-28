extends Node

# warning-ignore:unused_signal
signal selectedvariable

var displayType = ''

func _ready():
	add_menuitems()
func _on_TextureRect_gui_input(event):
	if (event is  InputEventMouseButton and  event.get_button_index()==1) and event.pressed:
		$"%GlobalsPopup".popup()

func add_menuitems():	
# warning-ignore:unused_variable
	var globalvars = []# Global.GlobalVariables.keys()
# warning-ignore:unused_variable
	var Subroutinevars = {}#Global.SubroutineVariables
	
